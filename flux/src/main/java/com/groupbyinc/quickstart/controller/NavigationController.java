package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.CloudBridge;
import com.groupbyinc.api.Query;
import com.groupbyinc.api.model.AbstractRecord;
import com.groupbyinc.api.model.AbstractResults;
import com.groupbyinc.api.model.Navigation;
import com.groupbyinc.api.model.Refinement;
import com.groupbyinc.api.model.RefinementsResult;
import com.groupbyinc.api.model.Results;
import com.groupbyinc.api.model.Sort;
import com.groupbyinc.api.model.refinement.RefinementValue;
import com.groupbyinc.common.util.io.IOUtils;
import com.groupbyinc.common.util.lang3.StringUtils;
import com.groupbyinc.quickstart.helper.Utils;
import com.groupbyinc.util.UrlBeautifier;
import com.groupbyinc.utils.Mappers;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspException;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Arrays.asList;

/**
 * NavigationController is the single entry point for search and navigation
 * in the quickstart application.
 */
@Controller
public class NavigationController {

    private HashMap<String, Query> queryQueue = new HashMap<String, Query>();
    private HashMap<String, CloudBridge> bridgeQueue = new HashMap<String, CloudBridge>();

    @RequestMapping(value = "/moreRefinements.html")
    ModelAndView getMoreNavigations(@RequestParam String navigationName, @RequestParam String selectedRefinements,
                                    HttpServletRequest request) throws IOException, JspException {

        String clientKey = getCookie(request, "clientKey", "").trim();

        Query query = queryQueue.get(clientKey);
        CloudBridge bridge = bridgeQueue.get(clientKey);

        navigationName = navigationName.trim();

        List<String> sRefinements = asList(selectedRefinements.split(","));
        Map<String, Object> model = new HashMap<String, Object>();
        List<Refinement> refinements = new ArrayList<Refinement>();
        Navigation selectedNavigation = new Navigation().setName(navigationName)
                                                        .setDisplayName(Utils.capitalize(navigationName));
        Navigation availableNavigation = new Navigation().setName(navigationName)
                                                         .setDisplayName(Utils.capitalize(navigationName));

        for(String ref : sRefinements){
            refinements.add(new RefinementValue().setValue(ref));
        }

        selectedNavigation.setRefinements(refinements);

        if(query == null || bridge == null) {
            model.put("results", null);
            model.put("nav", selectedNavigation);
            return new ModelAndView("includes/navLink.jsp", model);
        }

        ResultsMock results = new ResultsMock();
        results.setSelectedNavigation(asList(selectedNavigation));

        RefinementsResult refinementsResults = bridge.refinements(
                new Query().setArea(query.getArea()).addRefinementsByString(query.getRefinementString()).setCollection(
                        query.getCollection()).addValueRefinement("gbi_stream_upload", "1"), navigationName);

        if(refinementsResults != null && refinementsResults.getNavigation() != null) {
            List<Refinement> refinementList = refinementsResults.getNavigation().getRefinements();
            if(refinementsResults.getNavigation().isOr()){
                availableNavigation.setOr(true);
            }
            availableNavigation.setRefinements(refinementList);
        }
        results.setAvailableNavigation(asList(availableNavigation));
        model.put("results", results);
        model.put("nav", availableNavigation);
        return new ModelAndView("/includes/navLink.jsp", model);
    }

    @RequestMapping({"**/index.html"})
    protected ModelAndView handleSearch(HttpServletRequest pRequest, HttpServletResponse pResponse)
            throws Exception {

        // Get the action from the request.
        String action = ServletRequestUtils.getStringParameter(pRequest, "action", null);

        // The UrlBeautifier deconstructs a URL into a query object.  You can create as many url
        // beautifiers as you want which may correspond to different kinds of urls that you want
        // to generate.  Here we construct one called 'default' that we use for every search and
        // navigation URL.
        UrlBeautifier defaultUrlBeautifier = UrlBeautifier.getUrlBeautifiers().get("default");
        if (defaultUrlBeautifier == null) {
            UrlBeautifier.createUrlBeautifier("default");
            defaultUrlBeautifier = UrlBeautifier.getUrlBeautifiers().get("default");
            defaultUrlBeautifier.addRefinementMapping('s', "size");
            defaultUrlBeautifier.setSearchMapping('q');
            defaultUrlBeautifier.setAppend("/index.html");
            defaultUrlBeautifier.addReplacementRule('/', ' ');
            defaultUrlBeautifier.addReplacementRule('\\', ' ');
        }

        // Create the query object from the beautifier
        Query query = defaultUrlBeautifier.fromUrl(pRequest.getRequestURI(), new Query());

        // return all fields with each record.
        // If there are specific fields defined, use these, otherwise default to showing all fields.
        boolean debug = false;
        String fieldString = getCookie(pRequest, "fields", "").trim();
        if (StringUtils.isNotBlank(fieldString)) {
            String[] fields = fieldString.split(",");
            for (String field : fields) {
                if (StringUtils.isNotBlank(field)) {
                    query.addFields(field.trim());
                }
                // this debug endpoint for search is temporary and maybe removed without warning.
                if (field.trim().equalsIgnoreCase("debug")) {
                    debug = true;
                    if (fields.length == 1) {
                        query.addFields("*");
                    }
                }
            }
        } else {
            query.addFields("*");
        }

        // Setup parameters for the bridge
        String customerId = getCookie(pRequest, "customerId", "").trim();
        String clientKey = getCookie(pRequest, "clientKey", "").trim();

        // Create the communications bridge to the cloud service.
        CloudBridge bridge = new CloudBridge(clientKey, customerId);

        // If a specific area is set in the url params set it on the query.
        // Areas are used to name space rules / query rewrites.
        String area = getCookie(pRequest, "area", "").trim();
        if (StringUtils.isNotBlank(area)) {
            query.setArea(area);
        }

        // Use a specific language
        // See the documentation for which language codes are available.
        String language = getCookie(pRequest, "language", "").trim();
        if (StringUtils.isNotBlank(language)) {
            query.setLanguage(language);
        }

        // If you have data in different collections you can specify the specific
        // collection you wish to query against.
        String collection = getCookie(pRequest, "collection", "").trim();
        if (StringUtils.isNotBlank(collection)) {
            query.setCollection(collection);
        }

        // You can specify the sort field and order of the results.
        String sortField = getCookie(pRequest, "sortField", "").trim();
        if (StringUtils.isNotBlank(sortField)) {
            String sortOrder = getCookie(pRequest, "sortOrder", "").trim();
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

        // If there are additional refinements that aren't being beautified get these from the
        // URL and add them to the query.
        String refinements = ServletRequestUtils.getStringParameter(pRequest, "refinements", "");
        if (StringUtils.isNotBlank(refinements)) {
            query.addRefinementsByString(refinements);
        }

        // If the search string has not been beautified get it from the URL parameters.
        String queryString = ServletRequestUtils.getStringParameter(pRequest, "q", "");
        if (StringUtils.isNotBlank(queryString)) {
            query.setQuery(queryString);
        }

        // If we're paging through results set the skip from the url params
        query.setSkip(ServletRequestUtils.getIntParameter(pRequest, "p", 0));

        // If the query is supposed to be beautified, and it was in fact in the URL params
        // send a redirect command to the browser to redirect to the beautified URL.
        String incoming = pRequest.getRequestURI();
        String beautified = pRequest.getContextPath() + defaultUrlBeautifier.toUrl(
                query.getQuery(), query.getRefinementString());
        if (!beautified.startsWith(incoming)) {
            pResponse.sendRedirect(beautified);
            return null;
        }

        // Define the page size.
        query.setPageSize(ServletRequestUtils.getIntParameter(pRequest, "ps", 50));

        // Create a model that we will pass into the rendering JSP
        Map<String, Object> model = new HashMap<String, Object>();
        ModelAndView modelAndView = new ModelAndView("getOrderList".equals(action) ? "orderList.jsp" : "index.jsp");
        modelAndView.addObject("model", model);

        // put back the customerId
        model.put("customerId", customerId);

        // If a specific biasing profile is set in the url params set it on the query.
        String biasingProfile = getCookie(pRequest, "biasingProfile", "").trim();

        // We will run this query multiple times for each biasing profile found
        String[] biasingProfiles = biasingProfile.split(",", -1);
        if (biasingProfiles.length == 0) {
            biasingProfiles = new String[]{""};
        }
        model.put("biasingProfileCount", biasingProfiles.length);

        for (int i = 0; i < biasingProfiles.length; i++) {
            String profile = biasingProfiles[i].trim();
            query.setBiasingProfile(null);
            if (StringUtils.isNotBlank(profile)) {
                query.setBiasingProfile(profile);
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
                    model.put("time" + i, System.currentTimeMillis() - startTime);
                }
                // pass the results into the view.
                model.put("results" + i, results);
                model.put(
                        "resultsJson" + i, debug ? doDebugQueryThroughUrl(clientKey, customerId, query)
                                                 : Mappers.writeValueAsString(results));
            } catch (Exception e) {
                // Something went wrong.
                e.printStackTrace();
                model.put("error" + i, e.getMessage());
                model.put("cause" + i, e.getCause());
                return modelAndView;
            }
        }

        if(StringUtils.isNotBlank(clientKey)) {
            queryQueue.put(clientKey, query);
            bridgeQueue.put(clientKey, bridge);
        }

        // render using index.jsp and the populated model.
        return modelAndView;
    }

    /**
     * Temporary method for debugging queries.  The debug parameter maybe discontinued without warning.
     *
     * @param clientKey
     * @param customerId
     * @param query
     * @return
     */
    private String doDebugQueryThroughUrl(String clientKey, String customerId, Query query) {
        DataOutputStream outputStream = null;
        InputStream inputStream = null;
        try {
            query.setReturnBinary(false);
            byte[] postData = query.getBridgeJson(clientKey).getBytes("UTF-8");

            // this debug endpoint for search is temporary and maybe removed without warning.
            URL url = new URL("https://" + customerId + ".groupbycloud.com/api/v1/search?debug");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setInstanceFollowRedirects(false);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("charset", "utf-8");
            conn.setRequestProperty("Content-Length", Integer.toString(postData.length));
            conn.setUseCaches(false);
            outputStream = new DataOutputStream(conn.getOutputStream());
            outputStream.write(postData);
            inputStream = conn.getInputStream();
            String response = IOUtils.toString(inputStream);
            return response;
        } catch (Exception e) {
            e.printStackTrace();
            return e.toString();
        } finally {
            IOUtils.closeQuietly(outputStream);
            IOUtils.closeQuietly(inputStream);
        }
    }

    /**
     * Helper method to get cookie values.  We use this for storing the clientKey and customerId, though
     * these values should typically be put in a properties file.
     *
     * @param pRequest
     * @param pName
     * @param pDefault
     * @return the value of the named cookie, or default if it was not found.
     */
    private String getCookie(HttpServletRequest pRequest, String pName, String pDefault) {
        Cookie[] cookies = pRequest.getCookies();
        if (pRequest.getCookies() != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(pName)) {
                    return URLDecoder.decode(cookie.getValue());
                }
            }
        }
        return pDefault;
    }

    private static class RecordMock extends AbstractRecord<RecordMock> {}
    private static class ResultsMock extends AbstractResults<RecordMock, ResultsMock> {}
}
