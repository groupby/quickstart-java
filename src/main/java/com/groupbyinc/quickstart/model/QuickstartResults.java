package com.groupbyinc.quickstart.model;

import com.groupbyinc.api.model.Results;

public class QuickstartResults extends Results {
	private String matchStrategy = null;
	
	public QuickstartResults(Results results) {
		super();
		this.setArea(results.getArea());
		this.setAvailableNavigation(results.getAvailableNavigation());
		this.setBiasingProfile(results.getBiasingProfile());
		this.setCorrectedQuery(results.getCorrectedQuery());
		this.setDidYouMean(results.getDidYouMean());
		this.setErrors(results.getErrors());
		this.setOriginalQuery(results.getOriginalQuery());
		this.setPageInfo(results.getPageInfo());
		this.setQuery(results.getQuery());
		this.setRecords(results.getRecords());
		this.setRedirect(results.getRedirect());
		this.setRelatedQueries(results.getRelatedQueries());
		this.setRewrites(results.getRewrites());
		this.setSelectedNavigation(results.getSelectedNavigation());
		this.setSiteParams(results.getSiteParams());
		this.setTemplate(results.getTemplate());
		this.setTotalRecordCount(results.getTotalRecordCount());
	}

	public String getMatchStrategy() {
		return matchStrategy;
	}

	public void setMatchStrategy(String matchStrategy) {
		this.matchStrategy = matchStrategy;
	}
}
