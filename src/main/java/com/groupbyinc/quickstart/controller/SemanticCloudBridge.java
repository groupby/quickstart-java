package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.AbstractBridge;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class SemanticCloudBridge extends AbstractBridge{
    private final String urlOveride;

    public SemanticCloudBridge(String clientKey, String pUrl) {
        super(clientKey, pUrl);
        this.urlOveride = pUrl;
    }

    @Override
    protected InputStream fireRequest(String url, Map<String, String> urlParams, String body, boolean returnBinary) throws IOException {
        System.out.println("querying: " + url);
        System.out.println(body);
        return super.fireRequest(urlOveride, urlParams, body, false);
    }
}
