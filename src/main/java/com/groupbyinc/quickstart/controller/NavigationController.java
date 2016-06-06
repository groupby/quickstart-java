package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.CloudBridge;
import com.groupbyinc.api.Query;
import com.groupbyinc.api.model.*;
import com.groupbyinc.api.request.RestrictNavigation;
import com.groupbyinc.common.apache.commons.io.IOUtils;
import com.groupbyinc.common.apache.commons.lang3.StringUtils;
import com.groupbyinc.common.apache.http.HttpEntity;
import com.groupbyinc.common.apache.http.client.methods.CloseableHttpResponse;
import com.groupbyinc.common.apache.http.client.methods.HttpPost;
import com.groupbyinc.common.apache.http.entity.StringEntity;
import com.groupbyinc.common.apache.http.impl.client.CloseableHttpClient;
import com.groupbyinc.common.apache.http.impl.client.HttpClients;
import com.groupbyinc.common.blip.BlipClient;
import com.groupbyinc.common.jackson.Mappers;
import com.groupbyinc.common.jackson.databind.DeserializationFeature;
import com.groupbyinc.common.jackson.databind.ObjectMapper;
import com.groupbyinc.util.UrlBeautifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.*;
import java.util.logging.Logger;

import static com.groupbyinc.common.jackson.core.JsonParser.Feature.ALLOW_SINGLE_QUOTES;
import static com.groupbyinc.common.jackson.core.JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES;
import static java.util.Collections.singletonList;

/**
 * NavigationController is the single entry point for search and navigation
 * in the quickstart application.
 */
@SuppressWarnings("WeakerAccess")
@Controller
public class NavigationController {

  private static final transient Logger LOG = Logger.getLogger(NavigationController.class.getSimpleName());

  private static final ObjectMapper OM = new ObjectMapper();
  private static final ObjectMapper OM_MATCH_STRATEGY = new ObjectMapper();


  // The UrlBeautifier deconstructs a URL into a query object.  You can create as many url
  // beautifiers as you want which may correspond to different kinds of urls that you want
  // to generate.  Here we construct one called 'default' that we use for every search and
  // navigation URL.
  private static UrlBeautifier defaultUrlBeautifier = null;

  static {
    OM.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    OM_MATCH_STRATEGY.enable(ALLOW_UNQUOTED_FIELD_NAMES).enable(ALLOW_SINGLE_QUOTES);
    UrlBeautifier.createUrlBeautifier("default");
    defaultUrlBeautifier = UrlBeautifier.getUrlBeautifiers().get("default");
    defaultUrlBeautifier.addRefinementMapping('s', "size");
    defaultUrlBeautifier.setSearchMapping('q');
    defaultUrlBeautifier.setAppend("/index.html");
    defaultUrlBeautifier.addReplacementRule('/', ' ');
    defaultUrlBeautifier.addReplacementRule('\\', ' ');
  }

  /**
   * We hold all the bridges in a map so we're not creating a new one for each request.
   * Ideally, there should only be one bridge per jvm and they are expensive to create but thread safe.
   */
  private static final Map<String, CloudBridge> BRIDGES = new HashMap<>();

  private final BlipClient blipClient;

  @Autowired
  public NavigationController(BlipClient blipClient) {
    this.blipClient = blipClient;
  }


  @RequestMapping({"**/index.html"})
  public String handleSearch(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    // Get the action from the request.
    String action = ServletRequestUtils.getStringParameter(request, "action", null);


    // Create the query object from the beautifier
    Query query = defaultUrlBeautifier.fromUrl(request.getRequestURI(), new Query());

    // return all fields with each record.
    // If there are specific fields defined, use these, otherwise default to showing all fields.
    String fieldString = getCookie(request, "fields", "").trim();

    // If an image field is specified, always ask for it with the request.
    String imageField = getCookie(request, "imageField", "");
    if (StringUtils.isNotBlank(imageField)) {
      fieldString += "," + imageField;
    }
    fieldString += ",id";

    if (StringUtils.isNotBlank(fieldString)) {
      String[] fields = fieldString.split(",");
      for (String field : fields) {
        if (StringUtils.isNotBlank(field)) {
          query.addFields(field.trim());
        }
      }
    } else {
      query.addFields("*");
    }

    // Setup parameters for the bridge
    String customerId = getCookie(request, "customerId", "").trim();
    String clientKey = getCookie(request, "clientKey", "").trim();
    boolean skipCache = !Boolean.valueOf(getCookie(request, "cache", "false"));

    /**
     * DO NOT create a bridge per request.  Create only one.
     * They are expensive and create HTTP connection pools behind the scenes.
     */
    CloudBridge bridge = getCloudBridge(clientKey, customerId, skipCache);

    // If a specific area is set in the url params set it on the query.
    // Areas are used to name space rules / query rewrites.
    String area = getCookie(request, "area", "").trim();
    if (StringUtils.isNotBlank(area)) {
      query.setArea(area);
    }

    // Use a specific language
    // See the documentation for which language codes are available.
    String language = getCookie(request, "language", "").trim();
    if (StringUtils.isNotBlank(language)) {
      query.setLanguage(language);
    }

    // Visitor is used in personalized relevance.
    String visitorId = getCookie(request, "visitorId", "").trim();
    if (StringUtils.isNotBlank(visitorId)) {
      query.setVisitorId(visitorId);
    }

    // Restrict Navigation (this performs two queries so may be slow)
    String restrictNavigationName = getCookie(request, "restrictNavigationName", "").trim();
    if (StringUtils.isNotBlank(restrictNavigationName)) {
      RestrictNavigation restrictNavigation = new RestrictNavigation().setName(restrictNavigationName);
      String restrictNavigationCount = getCookie(request, "restrictNavigationCount", "").trim();
      if (StringUtils.isNotBlank(restrictNavigationCount)) {
        try {
          restrictNavigation.setCount(new Integer(restrictNavigationCount));
        } catch (Exception e) {
          LOG.warning("Couldn't parse restrictNavigation count: " + restrictNavigationCount + " " + e.getMessage());
        }
      }
      query.setRestrictNavigation(restrictNavigation);
    }

    // By default refinements that
    boolean dontPruneRefinements = Boolean.valueOf(getCookie(request, "dontPruneRefinements", "false"));
    if (dontPruneRefinements) {
      query.setPruneRefinements(false);
    }

    // By default refinements that
    boolean disableAutocorrection = Boolean.valueOf(getCookie(request, "disableAutocorrection", "false"));
    if (disableAutocorrection) {
      query.setDisableAutocorrection(true);
    }

    // By default refinements that
    String customUrlParameters = getCookie(request, "customUrlParameters", "");
    if (StringUtils.isNotBlank(customUrlParameters)) {
      query.addCustomUrlParamsByString(customUrlParameters);
    }

    // If you have data in different collections you can specify the specific
    // collection you wish to query against.
    String collection = getCookie(request, "collection", "").trim();
    if (StringUtils.isNotBlank(collection)) {
      query.setCollection(collection);
    }

    // Set the page size
    String pageSize = getCookie(request, "pageSize", "").trim();
    if (StringUtils.isNotBlank(pageSize)) {
      try {
        query.setPageSize(new Integer(pageSize));
      } catch (NumberFormatException e) {
        query.setPageSize(10);
      }
    }

    // You can specify the sort field and order of the results.
    String sortField = getCookie(request, "sortField", "").trim();
    if (StringUtils.isNotBlank(sortField)) {
      String sortOrder = getCookie(request, "sortOrder", "").trim();
      String[] fields = sortField.split(",");
      String[] orders = sortOrder.split(",");
      for (int i = 0; i < fields.length; i++) {
        String field = fields[i].trim();
        String order = i < orders.length ? orders[i].trim() : null;

        Sort sort = new Sort().setField(field);
        if (StringUtils.isNotBlank(order)) {
          if ("D".equals(order)) {
            sort.setOrder(Sort.Order.Descending);
          }
        }
        query.setSort(sort);
      }
    }

    String includedNavigations = getCookie(request, "includedNavigations", "").trim();
    if (StringUtils.isNotBlank(includedNavigations)) {
      for (String name : StringUtils.split(includedNavigations, ",")) {
        query.addIncludedNavigations(name.trim());
      }
    }

    String excludedNavigations = getCookie(request, "excludedNavigations", "").trim();
    if (StringUtils.isNotBlank(excludedNavigations)) {
      for (String name : StringUtils.split(excludedNavigations, ",")) {
        query.addExcludedNavigations(name.trim());
      }
    }

    String bringToTop = getCookie(request, "bringToTop", "").trim();
    if (StringUtils.isNotBlank(bringToTop)) {
      for (String name : StringUtils.split(bringToTop, ",")) {
        query.setBringToTop(name.trim());
      }
    }

    // If there are additional refinements that aren't being beautified get these from the
    // URL and add them to the query.
    String refinements = ServletRequestUtils.getStringParameter(request, "refinements", "");
    if (StringUtils.isNotBlank(refinements)) {
      query.addRefinementsByString(refinements);
    }

    // If the search string has not been beautified get it from the URL parameters.
    String queryString = ServletRequestUtils.getStringParameter(request, "q", "");
    if (StringUtils.isNotBlank(queryString)) {
      query.setQuery(queryString);
    }

    // If we're paging through results set the skip from the url params
    query.setSkip(ServletRequestUtils.getIntParameter(request, "p", 0));

    // If the query is supposed to be beautified, and it was in fact in the URL params
    // send a redirect command to the browser to redirect to the beautified URL.
    String incoming = request.getRequestURI();
    String beautified = request.getContextPath() + defaultUrlBeautifier.toUrl(
        query.getQuery(), query.getNavigations());
    if (!beautified.startsWith(incoming)) {
      response.sendRedirect(beautified);
      return null;
    }

    // Create a model that we will pass into the rendering JSP
    String view = "getOrderList".equals(action) ? "orderList" : "index";
    model.put("model", model);

    // put back the customerId
    model.put("customerId", customerId);

    model.put("collections", getCollections(customerId, clientKey));

    // If a specific biasing profile is set in the url params set it on the query.
    String biasingProfile = getCookie(request, "biasingProfile", "").trim();

    // We will run this query multiple times for each biasing profile found
    String[] biasingProfiles = biasingProfile.split(",", -1);
    if (biasingProfiles.length == 0) {
      biasingProfiles = new String[]{""};
    }
    model.put("biasingProfileCount", biasingProfiles.length);


    // If a specific match strategy is set.
    String matchStrategy = getCookie(request, "matchStrategy", "").trim();
    // We will run this query multiple times for each biasing profile found
    String[] matchStrategies = matchStrategy.split("\\|", -1);
    if (matchStrategies.length != biasingProfiles.length) {
      matchStrategies = new String[biasingProfiles.length];
      for (int i = 0; i < matchStrategies.length; i++) {
        matchStrategies[i] = "";
      }
    }
    // Put match strategies back in request
    model.put("matchStrategies", matchStrategies);
    List<String> matchStrategyErrors = new ArrayList<>();
    model.put("matchStrategyErrors", matchStrategyErrors);

    // deal with column sorts.
    List<Sort> originalSorts = new ArrayList<>(query.getSort());
    List<List<Sort>> colSorts = getColSorts(request, biasingProfiles.length, model);
    model.put("moreRefinementsQuery", OM.writeValueAsString(query));
    for (int i = 0; i < biasingProfiles.length; i++) {
      String profile = biasingProfiles[i].trim();
      String strategy = matchStrategies[i].trim();
      query.getSort().clear();
      query.getSort().addAll(originalSorts);
      query.setBiasingProfile(null);
      query.setMatchStrategy(null);
      if (StringUtils.isNotBlank(profile)) {
        query.setBiasingProfile(profile);
      }
      if (StringUtils.isNotBlank(strategy)) {
        query.setMatchStrategy(createMatchStrategy(matchStrategyErrors, strategy));
      }
      if (colSorts.get(i) != null) {
        query.getSort().clear();
        query.getSort().addAll(colSorts.get(i));
      }
      // pass the raw json representation of the query into the view regardless of errors
      model.put("rawQuery" + i, query.setReturnBinary(false).getBridgeJson(clientKey));
      model.put("originalQuery" + i, query);
      query.setReturnBinary(true);
      try {
        // execute the query
        Results results = new Results();
        if (StringUtils.isNotBlank(clientKey)) {
          long startTime = System.currentTimeMillis();
          results = bridge.search(query);
          long duration = System.currentTimeMillis() - startTime;
          model.put("time" + i, duration);

          blipClient.send("customerId", customerId,
              "eventType", "query",
              "columns", String.valueOf(biasingProfiles.length),
              "durationMillis", String.valueOf(duration));
        }
        // pass the results into the view.
        model.put("results" + i, results);
        model.put("resultsJson" + i, Mappers.writeValueAsString(results));
      } catch (Exception e) {
        blipClient.send("customerId", customerId,
            "eventType", "error",
            "message", e.getMessage());
        LOG.warning(e.getMessage());
        model.put("error" + i, e.getMessage());
        model.put("cause" + i, e.getCause());
      }
    }

    // render using index.jsp and the populated model.
    return view;
  }

  @SuppressWarnings("unchecked")
  private List<List<Sort>> getColSorts(HttpServletRequest request, int length, Map model) {
    Map<String, String[]> cs = new HashMap<>();
    Map<String, String[]> cd = new HashMap<>();
    for (int columns = 1; columns < 6; columns++) {
      String colSort = getCookie(request, "colSort" + columns, "");
      cs.put("colSorts" + columns, colSort.split("\\|", -1));
      String colDir = getCookie(request, "colDir" + columns, "");
      cd.put("colDirs" + columns, colDir.split("\\|", -1));
      model.put("sort" + columns, cs.get("colSorts" + columns));
      model.put("sort" + columns + "Direction", cd.get("colDirs" + columns));
    }


    List<List<Sort>> colSorts = new ArrayList<>();
    for (int column = 0; column < length; column++) {
      List<Sort> sorts = null;
      if (cs.get("colSorts1").length > column) {

        for (int row = 1; row < 6; row++) {
          if (StringUtils.isNotBlank(cs.get("colSorts" + row)[column])) {
            if (sorts == null) {
              sorts = new ArrayList<>();
            }
            Sort sort = new Sort();
            sort.setField(cs.get("colSorts" + row)[column]);
            if (StringUtils.isNotBlank(cd.get("colDirs" + row)[column])
                && cd.get("colDirs" + row)[column].toLowerCase().startsWith("d")) {
              sort.setOrder(Sort.Order.Descending);
            } else {
              sort.setOrder(Sort.Order.Ascending);
            }
            sorts.add(sort);
          }
        }
      }
      colSorts.add(sorts);
    }
    return colSorts;
  }

  private MatchStrategy createMatchStrategy(List<String> matchStrategyErrors, String strategy) {
    try {
      Map ms = OM_MATCH_STRATEGY.readValue(strategy, Map.class);
      MatchStrategy matchStrategy = new MatchStrategy();
      List rules = (List) ms.get("rules");
      for (Object rule : rules) {
        matchStrategy.getRules().add(OM_MATCH_STRATEGY.readValue(OM_MATCH_STRATEGY.writeValueAsString(rule), PartialMatchRule.class));
      }
      matchStrategyErrors.add("");
      return matchStrategy;
    } catch (Exception e) {
      e.printStackTrace();
      matchStrategyErrors.add(e.getMessage());
      return null;
    }
  }

  @SuppressWarnings("unchecked")
  public static List<String> getCollections(String customerId, String clientKey) {
    List<String> collections = new ArrayList<>();
    if (!StringUtils.isBlank(customerId) && !StringUtils.isBlank(clientKey)) {
      try {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost getCollections = new HttpPost("https://" + customerId + ".groupbycloud.com/api/v1/collections");
        getCollections.setEntity(new StringEntity("{clientKey: '" + clientKey + "'}", "UTF-8"));
        CloseableHttpResponse response = httpClient.execute(getCollections);
        HttpEntity responseEntity = response.getEntity();
        LOG.info(response.getStatusLine().toString());
        if (response.getStatusLine().getStatusCode() == 200) {
          String serverResponse = IOUtils.toString(responseEntity.getContent());
          LOG.info(serverResponse);
          Map collectionsMap = Mappers.readValue(serverResponse.getBytes("UTF-8"), Map.class, false);
          Map collectionMap = (Map) collectionsMap.get("collections");
          if (collectionMap != null) {
            Set<String> set = collectionMap.keySet();
            for (String collection : set) {
              if (!collection.endsWith("-variants")) {
                collections.add(collection);
              }
            }
          }
        }
        return collections;
      } catch (IOException e) {
        LOG.warning("Couldn't load collections: " + e.getMessage());
      }
    }
    return collections;
  }

  @RequestMapping(method = RequestMethod.POST, value = "**/moreRefinements.html")
  public String getMoreNavigations(Map<String, Object> model,
                                   HttpServletRequest request) throws ServletException {
    try {
      String clientKey = getCookie(request, "clientKey", "").trim();
      String customerId = getCookie(request, "customerId", "").trim();
      String originalQuery = ServletRequestUtils.getRequiredStringParameter(request, "originalQuery");
      String navigationName = ServletRequestUtils.getRequiredStringParameter(request, "navigationName");
      boolean skipCache = !Boolean.valueOf(getCookie(request, "cache", "false"));
      /**
       * DO NOT create a bridge per request.  Create only one.
       * They are expensive and create HTTP connection pools behind the scenes.
       */
      CloudBridge bridge = getCloudBridge(clientKey, customerId, skipCache);

      Query query = OM.readValue(originalQuery, Query.class);
      navigationName = navigationName.trim();
      Navigation availableNavigation = new Navigation().setName(navigationName);

      Results results = new Results();
      results.setSelectedNavigation(new ArrayList<>(query.getNavigations().values()));
      RefinementsResult refinementsResults = bridge.refinements(query, navigationName);

      if (refinementsResults != null && refinementsResults.getNavigation() != null) {
        List<Refinement> refinementList = refinementsResults.getNavigation().getRefinements();
        if (refinementsResults.getNavigation().isOr()) {
          availableNavigation.setOr(true);
        }
        availableNavigation.setDisplayName(refinementsResults.getNavigation().getDisplayName());
        availableNavigation.setRefinements(refinementList);
      }
      results.setQuery(query.getQuery());
      results.setAvailableNavigation(singletonList(availableNavigation));
      model.put("results", results);
      model.put("nav", availableNavigation);
      return "/includes/navLink";
    } catch (IOException e) {
      throw new ServletException(e);
    }
  }

  private CloudBridge getCloudBridge(String clientKey, String customerId, boolean skipCache) {
    String key = customerId + clientKey + String.valueOf(skipCache);
    if (!BRIDGES.containsKey(key)) {
      CloudBridge cb = new CloudBridge(clientKey, customerId);
      if (skipCache) {
        cb.setCachingEnabled(false);
      }
      BRIDGES.put(key, cb);
    }
    return BRIDGES.get(key);
  }


  /**
   * Helper method to get cookie values.  We use this for storing the clientKey and customerId, though
   * these values should typically be put in a properties file.
   */
  private String getCookie(HttpServletRequest pRequest, String pName, String pDefault) {
    Cookie[] cookies = pRequest.getCookies();
    if (pRequest.getCookies() != null) {
      for (Cookie cookie : cookies) {
        if (cookie.getName().equals(pName)) {
          try {
            return URLDecoder.decode(cookie.getValue(), "UTF-8");
          } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
          }
        }
      }
    }
    return pDefault;
  }
}
