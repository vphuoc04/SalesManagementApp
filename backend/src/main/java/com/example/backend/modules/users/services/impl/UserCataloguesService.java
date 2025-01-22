package com.example.backend.modules.users.services.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.users.entities.UserCatalogues;
import com.example.backend.modules.users.repositories.UserCataloguesRepository;
import com.example.backend.modules.users.requests.UserCatalogues.StoreRequest;
import com.example.backend.modules.users.services.interfaces.UserCataloguesServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class UserCataloguesService extends BaseService implements UserCataloguesServiceInterface {
    @Autowired
    private UserCataloguesRepository userCataloguesRepository;

    @Override
    @Transactional
    public UserCatalogues create(StoreRequest request) {
        try {
            UserCatalogues userCatalogues = UserCatalogues.builder()
                .name(request.getName())
                .publish(request.getPublish())
                .build();

            return userCataloguesRepository.save(userCatalogues);
        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }   
}
