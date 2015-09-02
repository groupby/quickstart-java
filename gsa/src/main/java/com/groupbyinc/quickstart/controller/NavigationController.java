package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.Bridge;
import com.groupbyinc.api.Query;
import com.groupbyinc.api.model.Results;
import com.groupbyinc.common.util.io.IOUtils;
import com.groupbyinc.common.util.lang3.StringUtils;
import com.groupbyinc.util.UrlBeautifier;
import com.groupbyinc.utils.Mappers;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.HashMap;

/**
 * NavigationController is the single entry point for search and navigation
 * in the quickstart application.
 */
public class NavigationController extends AbstractController {
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest pRequest, HttpServletResponse pResponse)
            throws Exception {
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

        // If a specific biasing profile is set in the url params set it on the query.
        String biasingProfile = getCookie(pRequest, "biasingProfile", "").trim();
        if (StringUtils.isNotBlank(biasingProfile)) {
            query.setBiasingProfile(biasingProfile);
        }

        // If you have data in different collections you can specify the specific
        // collection you wish to query against.
        String collection = getCookie(pRequest, "collection", "").trim();
        if (StringUtils.isNotBlank(collection)) {
            query.setCollection(collection);
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
        query.setPageSize(ServletRequestUtils.getIntParameter(pRequest, "ps", 10));

        // Create a model that we will pass into the rendering JSP
        HashMap<String, Object> model = new HashMap<String, Object>();
        model.put("customerId", customerId);

        // pass the raw json representation of the query into the view regardless of errors
        model.put("rawQuery", query.setReturnBinary(false).getBridgeJson(clientKey));
        model.put("originalQuery", query);
        query.setReturnBinary(true);

        try {
            // execute the query
            Results results = new Results();
            if (StringUtils.isNotBlank(clientKey)) {
                String bridgeHost = "localhost";
                int bridgePort = 9060;
                Bridge bridge = new Bridge(clientKey, bridgeHost, bridgePort);
                long startTime = System.currentTimeMillis();
                results = bridge.search(query);
                model.put("time", System.currentTimeMillis() - startTime);
            }
            // pass the results into the view.
            model.put("results", results);
            model.put("resultsJson", debug ? doDebugQueryThroughUrl(clientKey, customerId, query) : Mappers
                    .writeValueAsString(results));


            // render using index.jsp and the populated model.
            return new ModelAndView("index.jsp", model);
        } catch (Exception e) {
            // Something went wrong.
            e.printStackTrace();
            model.put("error", e.getMessage());
            model.put("cause", e.getCause());
            return new ModelAndView("index.jsp", model);
        }
    }

    /**
     * Temporary method for debugging queries.  The debug parameter maybe discontinued without warning.
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
            HttpURLConnection cox = (HttpURLConnection) url.openConnection();
            cox.setDoOutput(true);
            cox.setDoInput(true);
            cox.setInstanceFollowRedirects(false);
            cox.setRequestMethod("POST");
            cox.setRequestProperty("Content-Type", "application/json");
            cox.setRequestProperty("charset", "utf-8");
            cox.setRequestProperty("Content-Length", Integer.toString(postData.length));
            cox.setUseCaches(false);
            outputStream = new DataOutputStream(cox.getOutputStream());
            outputStream.write(postData);
            inputStream = cox.getInputStream();
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

}
