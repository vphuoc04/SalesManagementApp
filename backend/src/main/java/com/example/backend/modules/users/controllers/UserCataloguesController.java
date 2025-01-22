package com.example.backend.modules.users.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.UserCatalogues;
import com.example.backend.modules.users.requests.UserCatalogues.StoreRequest;
import com.example.backend.modules.users.resources.UserCataloguesResource;
import com.example.backend.modules.users.services.interfaces.UserCataloguesServiceInterface;
import com.example.backend.resources.ResponseResource;

import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class UserCataloguesController {
    private final UserCataloguesServiceInterface userCatagoluesService;

    public UserCataloguesController(
        UserCataloguesServiceInterface userCatagoluesService
    ){
        this.userCatagoluesService = userCatagoluesService;
    }

    @PostMapping("/user_catalogues")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request) {
        try {
            UserCatalogues userCatalogues = userCatagoluesService.create(request);

            UserCataloguesResource userCataloguesResource = UserCataloguesResource.builder()
                .id(userCatalogues.getId())
                .name(userCatalogues.getName())
                .publish(userCatalogues.getPublish())
                .build();

            ResponseResource<UserCataloguesResource> response = ResponseResource.ok(
                userCataloguesResource, 
                "Add new group member successfully!"
            );

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ResponseResource.message("Network error!", HttpStatus.UNAUTHORIZED));
        }
    }
}
