package com.example.backend.modules.users.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.UserCatalogues;
import com.example.backend.modules.users.repositories.UserCataloguesRepository;
import com.example.backend.modules.users.requests.UserCatalogues.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogues.UpdateRequest;
import com.example.backend.modules.users.resources.UserCataloguesResource;
import com.example.backend.modules.users.services.interfaces.UserCataloguesServiceInterface;
import com.example.backend.resources.ResponseResource;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class UserCataloguesController {
    private final UserCataloguesServiceInterface userCatagoluesService;

    @Autowired
    private UserCataloguesRepository userCataloguesRepository;

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

    @PutMapping("/user_catalogues/{id}")
    public ResponseEntity<?> update(@PathVariable("id") Long id, @Valid @RequestBody UpdateRequest request) {
        try {
            UserCatalogues userCatalogues = userCatagoluesService.update(id, request);

            UserCataloguesResource userCataloguesResource = UserCataloguesResource.builder()
                .id(userCatalogues.getId())
                .name(userCatalogues.getName())
                .publish(userCatalogues.getPublish())
                .build();

            ResponseResource<UserCataloguesResource> response = ResponseResource.ok(userCataloguesResource, "User group updated successfully");

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ResponseResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ResponseResource.error("NTERNAL_SERVER_ERROR", "Error: ", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }
    }
    
    @DeleteMapping("/user_catalogues/{id}")
    public ResponseEntity<?> delete(@PathVariable("id") Long id) {
        try {
            boolean deleted = userCatagoluesService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ResponseResource.message("Group deleted successfully!", HttpStatus.OK)
                );
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                    ResponseResource.error("NOT_FOUND", "Group not found!", HttpStatus.NOT_FOUND)
                );
            }

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ResponseResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ResponseResource.error("NTERNAL_SERVER_ERROR", "Error: ", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }
    }

    @GetMapping("/user_catalogues")
    public ResponseEntity<?> getAll() {
        try {
            List<UserCatalogues> userCataloguesList = userCataloguesRepository.findAll(); 

            List<UserCataloguesResource> userCataloguesResourceList = userCataloguesList.stream()
                .map(userCatalogues -> UserCataloguesResource.builder()
                    .id(userCatalogues.getId())
                    .name(userCatalogues.getName())
                    .publish(userCatalogues.getPublish())
                    .build())
                .collect(Collectors.toList());

            ResponseResource<List<UserCataloguesResource>> response = ResponseResource.ok(userCataloguesResourceList, "User groups fetched successfully");

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ResponseResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ResponseResource.error("INTERNAL_SERVER_ERROR", "Error: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }
    }
}
