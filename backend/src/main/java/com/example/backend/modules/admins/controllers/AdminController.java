package com.example.backend.modules.admins.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @GetMapping("admin/{id}")
    public ResponseEntity<?> admin(@PathVariable("id") Long id) {
        Admin admin = adminRepository.findById(id).orElseThrow(() -> new RuntimeException("Admin not found!"));

        AdminResource adminResource = AdminResource.builder()
            .id(admin.getId())
            .email(admin.getEmail())
            .firstName(admin.getFirstName())
            .middleName(admin.getMiddleName())
            .lastName(admin.getLastName())
            .phone(admin.getPhone())
            .build();

        SuccessResource<AdminResource> response = new SuccessResource<>("Success", adminResource);

        return ResponseEntity.ok(response);
    }
}
