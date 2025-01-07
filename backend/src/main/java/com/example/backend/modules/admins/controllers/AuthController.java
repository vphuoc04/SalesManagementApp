package com.example.backend.modules.admins.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.admins.requests.LoginRequest;
import com.example.backend.modules.admins.resources.LoginResource;
import com.example.backend.modules.admins.services.interfaces.AdminServiceInterface;
import com.example.backend.resources.ResponseResource;

import jakarta.validation.Valid;

@Validated
@RestController
@RequestMapping("api/v1/auth")
public class AuthController {
    private final AdminServiceInterface adminService;

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
}
