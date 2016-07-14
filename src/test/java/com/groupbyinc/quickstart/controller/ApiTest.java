package com.groupbyinc.quickstart.controller;

import com.groupbyinc.api.Query;
import org.junit.Test;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;

import static org.junit.Assert.assertEquals;

public class ApiTest {

  @Test
  public void testApiCompleteness(){
    Field[] declaredFields = Query.class.getDeclaredFields();
    int count = 0 ;
    for (Field declaredField : declaredFields) {

      if (!Modifier.isFinal(declaredField.getModifiers()) && !Modifier.isStatic(declaredField.getModifiers())){
        count++;
      }
    }
    assertEquals("The API has changed, you must now implement whatever was added to the interface", 24, count);
  }
}