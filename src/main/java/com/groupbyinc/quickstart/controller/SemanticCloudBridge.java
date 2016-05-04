package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.AbstractBridge;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class SemanticCloudBridge extends AbstractBridge{
    private final String urlOveride;

    public SemanticCloudBridge(String clientKey, String pCustomerId) {
        super(clientKey, "http://130.211.128.46/semanticSearch/" + pCustomerId);
        this.urlOveride = "http://130.211.128.46/semanticSearch/" + pCustomerId;
    }

    @Override
    protected InputStream fireRequest(String url, Map<String, String> urlParams, String body, boolean returnBinary) throws IOException {
        return super.fireRequest(urlOveride, urlParams, body, false);
    }
}
