package com.groupbyinc.quickstart.helper;

import com.groupbyinc.api.model.MatchStrategy;
import com.groupbyinc.api.model.Navigation;
import com.groupbyinc.api.model.PartialMatchRule;
import com.groupbyinc.api.model.Refinement;
import com.groupbyinc.api.model.Results;
import com.groupbyinc.api.model.refinement.RefinementValue;
import com.groupbyinc.common.jackson.core.JsonParseException;
import com.groupbyinc.common.jackson.core.type.TypeReference;
import com.groupbyinc.common.jackson.databind.JsonMappingException;
import com.groupbyinc.common.jackson.databind.ObjectMapper;
import com.groupbyinc.quickstart.model.QuickstartResults;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by ferron on 5/5/15.
 */
public class Utils {

    public static List<Navigation> getSelectedNavigations(String refinements){
        List<Navigation> selectedNavigations = new ArrayList<Navigation>();
        if(!refinements.isEmpty()){
            String[] refs = refinements.split(",");
            for(String s : refs){
                String[] navsAndRefs = s.split("=");
                int index = selectedNavigations.indexOf(new Navigation().setName(navsAndRefs[0]));
                if(index != -1){
                    selectedNavigations.get(index).getRefinements().add(new RefinementValue().setValue(navsAndRefs[1]));
                } else{
                    List<Refinement> refVals = new ArrayList<Refinement>();
                    refVals.add(new RefinementValue().setValue(navsAndRefs[1]));
                    selectedNavigations.add(new Navigation().setName(navsAndRefs[0]).setRefinements(refVals));
                }
            }
        }
        return selectedNavigations;
    }
    
	public static MatchStrategy getMatchStrategy(String jsonString) {
		jsonString = jsonString.replace("'", "\"");
		
		if (!(jsonString.startsWith("[") && jsonString.endsWith("]"))) {
			jsonString = "[" + jsonString + "]";
		} else if (!jsonString.startsWith("[") || !jsonString.endsWith("]")) {
			return null;
		}
		ObjectMapper mapper = new ObjectMapper();
		List<PartialMatchRule> rules = null;
		try {
			rules = mapper.readValue(jsonString, new TypeReference<List<PartialMatchRule>>(){});
		} catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		MatchStrategy matchStrategy = null;
		
		if (rules != null) {
			matchStrategy = new MatchStrategy();
			matchStrategy.setRules(rules);
		}
		
		return matchStrategy;
	}
}
