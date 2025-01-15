package com.example.backend.modules.users.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.resources.UserResource;
import com.example.backend.resources.SuccessResource;

@RestController
@RequestMapping("api/v1")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping("user/{id}")
    public ResponseEntity<?> admin(@PathVariable("id") Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found!"));

        UserResource adminResource = UserResource.builder()
            .id(user.getId())
            .email(user.getEmail())
            .firstName(user.getFirstName())
            .middleName(user.getMiddleName())
            .lastName(user.getLastName())
            .phone(user.getPhone())
            .build();

        SuccessResource<UserResource> response = new SuccessResource<>("Success", adminResource);

        return ResponseEntity.ok(response);
    }
}
