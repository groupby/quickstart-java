package com.groupbyinc.quickstart.helper;

import com.groupbyinc.api.model.Navigation;
import com.groupbyinc.api.model.Refinement;
import com.groupbyinc.api.model.refinement.RefinementValue;

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
}
