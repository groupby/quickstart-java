package com.groupbyinc.quickstart.controller;

public class MissingImageAttributeException extends Exception {
    String imageAttributeName = null;
    
    public MissingImageAttributeException() {
        super();
    }
    
    public MissingImageAttributeException(Exception e) {
        super(e);
    }
    
    public MissingImageAttributeException(String message, Throwable cause) {
        super(message, cause);
    }

    public String getImageAttributeName() {
        return imageAttributeName;
    }

    public void setImageAttributeName(String imageAttributeName) {
        this.imageAttributeName = imageAttributeName;
    }
}
