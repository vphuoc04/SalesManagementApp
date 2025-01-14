package com.example.backend.modules.admins.resources;

public class LoginResource {
    private final String token;
    private final String refreshToken;
    private final AdminResource admin;

    public LoginResource(
        String token,
        String refreshToken,
        AdminResource admin
    ){
        this.token = token;
        this.refreshToken = refreshToken;
        this.admin = admin;
    }

    public String getToken() {
        return token;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public AdminResource getAdmin() {
        return admin;
    }
}
