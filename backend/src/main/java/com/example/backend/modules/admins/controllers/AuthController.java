package com.example.backend.modules.admins.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.admins.requests.BlacklistTokenRequest;
import com.example.backend.modules.admins.requests.LoginRequest;
import com.example.backend.modules.admins.resources.LoginResource;
import com.example.backend.modules.admins.services.impl.BlacklistService;
import com.example.backend.modules.admins.services.interfaces.AdminServiceInterface;
import com.example.backend.resources.MessageResourece;
import com.example.backend.resources.ResponseResource;

import jakarta.validation.Valid;

@Validated
@RestController
@RequestMapping("api/v1/auth")
public class AuthController {
    private final AdminServiceInterface adminService;

    @Autowired
    private BlacklistService blacklistService;

    public AuthController(
        AdminServiceInterface adminService
    ){
        this.adminService = adminService;
    }

    @PostMapping("login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        Object result = adminService.authenticate(request);

        if(result instanceof LoginResource loginResource) {
            return ResponseEntity.ok(loginResource);
        }

        if(result instanceof ResponseResource responseResource) {
            return ResponseEntity.unprocessableEntity().body(responseResource);
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Network errors");
    }

    @PostMapping("blacklisted_tokens")
    public ResponseEntity<?> addTokenToBlacklist(@Valid @RequestBody BlacklistTokenRequest request) {
        try {
            Object result = blacklistService.create(request);

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(new MessageResourece("Network error!"));
        }
    }

    @GetMapping("logout")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            
            BlacklistTokenRequest request = new BlacklistTokenRequest();
            request.setToken(token);

            Object message = blacklistService.create(request);
            return ResponseEntity.ok(message);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(new MessageResourece("Network error!"));
        }
    }
}
