package com.groupbyinc.quickstart.controller.model;

import java.util.Map;

/**
 * CollectionsData
 *
 * @author groupby
 */
public class CollectionsResult {

  private Map<String, Integer> collections;

  public Map<String, Integer> getCollections() {
    return collections;
  }

  public void setCollections(Map<String, Integer> collections) {
    this.collections = collections;
  }
}
