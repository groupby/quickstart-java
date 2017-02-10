package com.groupbyinc.quickstart.controller;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.groupbyinc.api.CloudBridge;
import com.groupbyinc.api.Query;
import com.groupbyinc.api.config.ConnectionConfiguration;
import com.groupbyinc.api.model.MatchStrategy;
import com.groupbyinc.api.model.Navigation;
import com.groupbyinc.api.model.PartialMatchRule;
import com.groupbyinc.api.model.Record;
import com.groupbyinc.api.model.Refinement;
import com.groupbyinc.api.model.RefinementsResult;
import com.groupbyinc.api.model.Results;
import com.groupbyinc.api.model.Sort;
import com.groupbyinc.api.request.RestrictNavigation;
import com.groupbyinc.common.apache.commons.io.IOUtils;
import com.groupbyinc.common.apache.commons.lang3.StringUtils;
import com.groupbyinc.common.apache.http.Header;
import com.groupbyinc.common.apache.http.HttpEntity;
import com.groupbyinc.common.apache.http.client.methods.CloseableHttpResponse;
import com.groupbyinc.common.apache.http.client.methods.HttpPost;
import com.groupbyinc.common.apache.http.entity.StringEntity;
import com.groupbyinc.common.apache.http.impl.client.CloseableHttpClient;
import com.groupbyinc.common.apache.http.impl.client.HttpClients;
import com.groupbyinc.common.apache.http.message.BasicHeader;
import com.groupbyinc.common.blip.BlipClient;
import com.groupbyinc.common.jackson.Mappers;
import com.groupbyinc.common.jackson.core.JsonParser;
import com.groupbyinc.quickstart.controller.model.Collection;
import com.groupbyinc.quickstart.controller.model.CollectionsResult;
import com.groupbyinc.util.UrlBeautifier;
import net.thisptr.jackson.jq.JsonQuery;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import static com.groupbyinc.api.config.ConnectionConfiguration.DEFAULT_CONNECT_TIMEOUT;
import static com.groupbyinc.api.config.ConnectionConfiguration.DEFAULT_SOCKET_TIMEOUT;
import static com.groupbyinc.common.jackson.core.JsonParser.Feature.ALLOW_SINGLE_QUOTES;
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
  private static final com.groupbyinc.common.jackson.databind.ObjectMapper OM_MATCH_STRATEGY = new com.groupbyinc.common.jackson.databind.ObjectMapper();
  /**
   * We hold all the bridges in a map so we're not creating a new one for each request.
   * Ideally, there should only be one bridge per jvm and they are expensive to create but thread safe.
   */
  private static final Map<String, CloudBridge> BRIDGES = new HashMap<>();
  // The UrlBeautifier deconstructs a URL into a query object.  You can create as many url
  // beautifiers as you want which may correspond to different kinds of urls that you want
  // to generate.  Here we construct one called 'default' that we use for every search and
  // navigation URL.
  private static UrlBeautifier defaultUrlBeautifier = null;

  static {
    OM.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    OM_MATCH_STRATEGY.enable(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES).enable(ALLOW_SINGLE_QUOTES);
    UrlBeautifier.createUrlBeautifier("default");
    defaultUrlBeautifier = UrlBeautifier.getUrlBeautifiers().get("default");
    defaultUrlBeautifier.addRefinementMapping('s', "size");
    defaultUrlBeautifier.setSearchMapping('q');
    defaultUrlBeautifier.setAppend("/index.html");
    defaultUrlBeautifier.addReplacementRule('/', ' ');
    defaultUrlBeautifier.addReplacementRule('\\', ' ');
  }

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
    String fieldString = getCookie(request, "fields", "*").trim();

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

    String sessionId = getCookie(request, "sessionId", "").trim();
    if (StringUtils.isNotBlank(sessionId)) {
      query.setSessionId(sessionId);
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
    String beautified = request.getContextPath() + defaultUrlBeautifier.toUrl(query.getQuery(), query.getNavigations());
    if (!beautified.startsWith(incoming)) {
      response.sendRedirect(beautified);
      return null;
    }

    // Create a model that we will pass into the rendering JSP
    String view = "getOrderList".equals(action) ? "orderList" : "index";
    model.put("model", model);

    // put back the customerId
    model.put("customerId", customerId);

    List<Collection> collections = getCollections(customerId, clientKey);
    model.put("collections", collections);
    int currentCollectionCount = collections.stream()
        .filter(d -> StringUtils.equals(d.getValue(), collection))
        .map(Collection::getCount)
        .findFirst()
        .orElse(-1);
    model.put("collectionCount", currentCollectionCount);

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

    // If skip semantish is on.
    String skipSemantish = getCookie(request, "skipSemantish", "").trim();
    String[] skipSemantishStrings = skipSemantish.split(",", -1);
    model.put("skipSemantish", skipSemantishStrings);
    if (skipSemantishStrings.length != biasingProfiles.length) {
      skipSemantishStrings = new String[biasingProfiles.length];
      for (int i = 0; i < skipSemantishStrings.length; i++) {
        skipSemantishStrings[i] = "false";
      }
    }

    // If wildcard is on.
    String wildcard = getCookie(request, "wildcard", "").trim();
    String[] wildcardStrings = wildcard.split(",", -1);
    model.put("wildcard", wildcardStrings);
    if (wildcardStrings.length != biasingProfiles.length) {
      wildcardStrings = new String[biasingProfiles.length];
      for (int i = 0; i < wildcardStrings.length; i++) {
        wildcardStrings[i] = "false";
      }
    }

    // deal with column sorts.
    List<Sort> originalSorts = new ArrayList<>(query.getSort());
    List<List<Sort>> colSorts = getColSorts(request, biasingProfiles.length, model);
    for (int i = 0; i < biasingProfiles.length; i++) {
      String profile = biasingProfiles[i].trim();
      String strategy = matchStrategies[i].trim();
      String wild = wildcardStrings[i];
      query.getSort().clear();
      query.getSort().addAll(originalSorts);
      query.setBiasingProfile(null);
      query.setMatchStrategy(null);
      query.setWildcardSearchEnabled("true".equals(wild));
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
      if (i == 0) {
        model.put("moreRefinementsQuery", Mappers.writeValueAsString(query));
      }
      model.put("rawQuery" + i, query.setReturnBinary(false).getBridgeJson(clientKey));
      model.put("originalQuery" + i, query);
      query.setReturnBinary(true);
      try {
        // execute the query
        Results results = new Results();
        if (StringUtils.isNotBlank(clientKey)) {
          ensureHeader(bridge, "Skip-Semantish", skipSemantishStrings[i]);
          logQuery(bridge, query);
          long startTime = System.currentTimeMillis();
          results = bridge.search(query);
          long duration = System.currentTimeMillis() - startTime;
          populateImages(request, results.getRecords());
          model.put("time" + i, duration);

          blipClient.send("customerId", customerId.toLowerCase(), "eventType", "query", "columns", String.valueOf(biasingProfiles.length), "durationMillis", String.valueOf(duration));
        }
        // pass the results into the view.
        model.put("recordLimitReached", results.getMetadata().isRecordLimitReached());
        model.put("results" + i, results);
        model.put("resultsJson" + i, Mappers.writeValueAsString(results));
        model.put("bridgeHeaders" + i, bridge.getHeaders());
      } catch (Exception e) {
        blipClient.send("customerId", customerId.toLowerCase(), "eventType", "error", "errorType", "searchError", "message", e.getMessage());
        LOG.warning(e.getMessage());
        model.put("error" + i, e.getMessage());
        model.put("cause" + i, e.getCause());
      }
    }

    // render using index.jsp and the populated model.
    return view;
  }

  private void logQuery(CloudBridge bridge, Query query) {
    LOG.info("Executing with headers: " + bridge.getHeaders());
    LOG.info("Query: " + query.getBridgeJson("****"));
  }

  private void ensureHeader(CloudBridge bridge, String headerName, String headerValue) {
    Iterator<Header> iterator = bridge.getHeaders().iterator();
    while (iterator.hasNext()) {
      Header header = iterator.next();
      if (header.getName().equalsIgnoreCase(headerName)) {
        iterator.remove();
      }
    }
    bridge.getHeaders().add(new BasicHeader(headerName, headerValue));
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
            if (StringUtils.isNotBlank(cd.get("colDirs" + row)[column]) && cd.get("colDirs" + row)[column].toLowerCase().startsWith("d")) {
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
  public static List<Collection> getCollections(String customerId, String clientKey) {
    List<Collection> collections = new ArrayList<>();
    if (!StringUtils.isBlank(customerId) && !StringUtils.isBlank(clientKey)) {
      try {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost getCollections = new HttpPost("https://" + customerId + ".groupbycloud.com/api/v1/collections");
        getCollections.setEntity(new StringEntity("{clientKey: '" + clientKey + "'}", "UTF-8"));
        CloseableHttpResponse response = httpClient.execute(getCollections);
        HttpEntity responseEntity = response.getEntity();
        LOG.info(response.getStatusLine().toString());
        if (response.getStatusLine().getStatusCode() == 200) {
          String serverResponse = IOUtils.toString(responseEntity.getContent(), "UTF-8");
          LOG.info(serverResponse);
          CollectionsResult collectionsResult = Mappers.readValue(serverResponse.getBytes("UTF-8"), CollectionsResult.class, false);
          Map<String, Integer> collectionsMap = collectionsResult.getCollections();
          if (collectionsMap != null) {
            for (Map.Entry<String, Integer> entry : collectionsMap.entrySet()) {
              if (!entry.getKey()
                  .endsWith("-variants")) {
                collections.add(new Collection().setLabel(entry.getKey() + " (" + entry.getValue() + ")")
                                    .setValue(entry.getKey())
                                    .setCount(entry.getValue()));
              }
            }
          }
        }
      } catch (IOException e) {
        LOG.warning("Couldn't load collections: " + e.getMessage());
      }
    }
    return collections;
  }

  @RequestMapping(method = RequestMethod.POST, value = "**/moreRefinements.html")
  public String getMoreNavigations(Map<String, Object> model, HttpServletRequest request) throws ServletException {
    String customerId = getCookie(request, "customerId", "").trim();
    try {
      String clientKey = getCookie(request, "clientKey", "").trim();
      String originalQuery = ServletRequestUtils.getRequiredStringParameter(request, "originalQuery");
      String navigationName = ServletRequestUtils.getRequiredStringParameter(request, "navigationName");
      boolean skipCache = !Boolean.valueOf(getCookie(request, "cache", "false"));
      /**
       * DO NOT create a bridge per request.  Create only one.
       * They are expensive and create HTTP connection pools behind the scenes.
       */
      CloudBridge bridge = getCloudBridge(clientKey, customerId, skipCache);

      Query query = Mappers.readValue(originalQuery.getBytes(), Query.class, false);
      navigationName = navigationName.trim();
      Navigation availableNavigation = new Navigation().setName(navigationName);

      Results results = new Results();
      results.setSelectedNavigation(new ArrayList<>(query.getNavigations().values()));
      long start = System.currentTimeMillis();
      RefinementsResult refinementsResults = bridge.refinements(query, navigationName);
      long duration = System.currentTimeMillis() - start;
      blipClient.send("eventType", "moreRefinements", "customerId", customerId.toLowerCase(), "navigationName", navigationName, "durationMillis", String.valueOf(duration));

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
      blipClient.send("customerId", customerId.toLowerCase(), "eventType", "error", "errorType", "moreRefinements", "message", e.getMessage());
      throw new ServletException(e);
    }
  }

  private CloudBridge getCloudBridge(String clientKey, String customerId, boolean skipCache) {
    String key = customerId + clientKey + String.valueOf(skipCache);
    if (!BRIDGES.containsKey(key)) {
      CloudBridge cb = new CloudBridge(clientKey, customerId, new ConnectionConfiguration(DEFAULT_CONNECT_TIMEOUT, 30000, DEFAULT_SOCKET_TIMEOUT));
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

  public void populateImages(HttpServletRequest request, List<Record> records) {
    String imageField = getCookie(request, "imageField", null);
    if (StringUtils.isBlank(imageField)) {
      return;
    }
    for (Record record : records) {
      ObjectMapper MAPPER = new ObjectMapper();
      try {
        JsonQuery q = JsonQuery.compile(".allMeta." + imageField);
        JsonNode in = MAPPER.readTree(MAPPER.writeValueAsString(record));
        List<JsonNode> result = q.apply(in);
        if (result != null && !result.isEmpty()) {
          record.getAllMeta().put("gbiInjectedImage", result.get(0).asText());
        }
      } catch (IOException e) {
        String msg = "Could not find image with jq query: " + imageField + " error: " + e.getMessage();
        record.getAllMeta().put("gbiInjectedImageError", msg);
        LOG.warning(msg);
      }
    }
  }
}
