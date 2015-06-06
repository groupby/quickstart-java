package com.groupbyinc.quickstart.helper;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ferron on 5/2/15.
 */
public class T {

    String template;
    Map<String, Object> options = new HashMap<String, Object>();

    public T(String template) {
        this.template = template;
    }

    public T add (String key, Object value) {
        options.put(key, value);
        return this;
    }

    public String render() {
        for (Map.Entry<String, Object> entry : options.entrySet()) {
            template = template.replaceAll(String.format("\\{%s\\}", entry.getKey()), entry.getValue().toString());
        }
        return template;
    }
}