package com.example.backend.modules.admins.controllers;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.admins.entities.Admin;
import com.example.backend.modules.admins.repositories.AdminRepository;
import com.example.backend.modules.admins.resources.AdminResource;
import com.example.backend.resources.SuccessResource;

@RestController
@RequestMapping("api/v1")
public class AdminController {
    @Autowired
    private AdminRepository adminRepository;

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @GetMapping("admin")
    public ResponseEntity<?> admin() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        logger.info(email);

        Admin admin = adminRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("Admin not found!"));

        AdminResource adminResource = new AdminResource(
            admin.getId(), 
            admin.getEmail(), 
            admin.getFirstName(), 
            admin.getMiddleName(), 
            admin.getLastName(), 
            admin.getPhone()
        );

        SuccessResource<AdminResource> response = new SuccessResource<>("Success", adminResource);

        return ResponseEntity.ok(response);
    }
}
