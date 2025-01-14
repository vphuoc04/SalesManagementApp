package com.example.backend.modules.admins.services.impl;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.backend.databases.seeders.DatabaseSeeder;
import com.example.backend.modules.admins.entities.Admin;
import com.example.backend.modules.admins.repositories.AdminRepository;
import com.example.backend.modules.admins.requests.LoginRequest;
import com.example.backend.modules.admins.resources.AdminResource;
import com.example.backend.modules.admins.resources.LoginResource;
import com.example.backend.modules.admins.services.interfaces.AdminServiceInterface;
import com.example.backend.resources.ResponseResource;
import com.example.backend.services.BaseService;
import com.example.backend.services.JwtService;

@Service
public class AdminService extends BaseService implements AdminServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseSeeder.class);

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncode;

    @Autowired
    private AdminRepository adminRepository;

    @Override
    public Object authenticate(LoginRequest request) {
        try {
            Admin admin = adminRepository.findByEmail(request.getEmail()).orElseThrow(() -> new BadCredentialsException("Incorrect email or password!"));

            if(!passwordEncode.matches(request.getPassword(), admin.getPassword())) {
                throw new BadCredentialsException("Incorrect email or password!");
            }

            AdminResource adminResource = AdminResource.builder()
                .id(admin.getId())
                .email(admin.getEmail())
                .firstName(admin.getFirstName())
                .middleName(admin.getMiddleName())
                .lastName(admin.getLastName())
                .phone(admin.getPhone())
                .build();
            
            String token = jwtService.generateToken(admin.getId(), admin.getEmail());
            String refreshToken = jwtService.generateRefreshToken(admin.getId(), admin.getEmail());

            return new LoginResource(token, refreshToken, adminResource);
        } catch (BadCredentialsException e) {
            logger.error("Authentication error: " + e.getMessage());
            Map<String, String> errors = new HashMap<>();
            errors.put("Message: ", e.getMessage());
            ResponseResource responseResource = new ResponseResource("Error: ", errors);

            return responseResource;
        }
    }
}
