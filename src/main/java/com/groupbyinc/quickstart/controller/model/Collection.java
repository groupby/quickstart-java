package com.groupbyinc.quickstart.controller.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * CollectionsData
 *
 * @author groupby
 */
public class Collection {

  private String label;
  private String value;
  @JsonIgnore private int count;

  public String getLabel() {
    return label;
  }

  public Collection setLabel(String label) {
    this.label = label;
    return this;
  }

  public String getValue() {
    return value;
  }

  public Collection setValue(String value) {
    this.value = value;
    return this;
  }

  public int getCount() {
    return count;
  }

  public Collection setCount(int count) {
    this.count = count;
    return this;
  }
}
