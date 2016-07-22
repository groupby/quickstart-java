package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.model.Record;
import com.groupbyinc.common.blip.BlipClient;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import javax.servlet.http.Cookie;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class NavigationControllerTest {

  @Test
  public void testImageCookie() {
    NavigationController test = new NavigationController(BlipClient.EMPTY);
    MockHttpServletRequest mockRequest = new MockHttpServletRequest();
    mockRequest.setCookies(new Cookie("imageField", "variants.[0].image"));
    List<Record> records = new ArrayList<>();
    Record record = new Record();
    record.setAllMeta(new HashMap<>());
    record.getAllMeta().put("title", "laptop");
    List variants = new ArrayList<>();
    Map<String, Object> variant1 = new HashMap<>();
    variant1.put("image", "variant1ImageUrl");
    variants.add(variant1);
    Map<String, Object> variant2 = new HashMap<>();
    variant2.put("image", "variant2ImageUrl");
    variants.add(variant2);
    records.add(record);
    record.getAllMeta().put("variants", variants);
    test.populateImages(mockRequest, records);
    assertEquals(1, records.size());
    assertEquals("", records.get(0).getAllMeta().get("gbiInjectedImage"));
  }

}