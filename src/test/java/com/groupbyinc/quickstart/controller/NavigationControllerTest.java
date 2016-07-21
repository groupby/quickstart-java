package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.model.Record;
import com.groupbyinc.common.blip.BlipClient;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class NavigationControllerTest {

  @Test
  public void testImageCookie() {
    NavigationController test = new NavigationController(BlipClient.EMPTY);
    MockHttpServletRequest mockRequest = new MockHttpServletRequest();
    List<Record> records = new ArrayList<>();
    Record record = new Record();
    record.getAllMeta().put("title", "laptop");
    records.add(record);
    test.populateImages(mockRequest, records);
    assertEquals(1, records.size());
  }

}