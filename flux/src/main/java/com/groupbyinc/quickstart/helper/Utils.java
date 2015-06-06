package com.groupbyinc.quickstart.helper;

import com.groupbyinc.api.model.Navigation;
import com.groupbyinc.api.model.Refinement;
import com.groupbyinc.api.model.refinement.RefinementValue;
import com.groupbyinc.api.tags.UrlFunctions;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.jsp.JspException;
import java.util.List;

/**
 * Created by ferron on 5/5/15.
 */
public class Utils {

    public static String buildTemplate(Refinement refinement, String navName,
                                       List<Navigation> navigations, String searchString)
            throws JspException {

        UriComponents beautifierUrl = ServletUriComponentsBuilder.fromUriString(
                UrlFunctions.toUrlAdd(
                        "default", searchString, navigations, navName, refinement)).build();

        UriComponentsBuilder context = ServletUriComponentsBuilder.fromCurrentContextPath().queryParams(
                beautifierUrl.getQueryParams()).path(beautifierUrl.getPath());

        return new T("<div><a style=\"color:white\" href=\"{url}\">{ref} ({count})</a></div>")
                .add("url", context.build(false).toUriString()) //
                .add("ref", formatRefinement(refinement))   //
                .add("count", refinement.getCount())    //
                .render();
    }

    private static String formatRefinement(Refinement refinement) {
        if (refinement instanceof RefinementValue) {
            return ((RefinementValue) refinement).getValue();
        }

        return null;
    }
}
