package com.example.backend.resources;

import java.util.Map;

public class ResponseResource {
    private String message;
    private Map<String, String> errors;

    public ResponseResource(
        String message,
        Map<String, String> errors
    ){
        this.message = message;
        this.errors = errors;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, String> getErrors() {
        return errors;
    }

    public void setError(Map<String, String> errors) {
        this.errors = errors;
    }
}
