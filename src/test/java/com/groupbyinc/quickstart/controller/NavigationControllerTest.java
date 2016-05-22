package com.groupbyinc.quickstart.controller;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class NavigationControllerTest {
    @Test
    public void getCollections() throws Exception {
        List<String> collections = NavigationController.getCollections("cabelas", "870a0a0f-23b2-441a-8883-d3c63531b310");
        assertEquals("[ProductsDev, ProductsProduction, ProductsTest, SAYT, test]", collections.toString());
    }

}