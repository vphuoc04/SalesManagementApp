package com.example.backend.modules.admins.resources;

public class LoginResource {
    private final String token;
    private final AdminResource admin;

    public LoginResource(
        String token,
        AdminResource admin
    ){
        this.token = token;
        this.admin = admin;
    }

    public String getToken() {
        return token;
    }

    public AdminResource getAdmin() {
        return admin;
    }
}
