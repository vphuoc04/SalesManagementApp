package com.example.backend.modules.users.services.interfaces;

import com.example.backend.modules.users.entities.UserCatalogues;
import com.example.backend.modules.users.requests.UserCatalogues.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogues.UpdateRequest;

public interface UserCataloguesServiceInterface {
   UserCatalogues create(StoreRequest request);
   UserCatalogues update(Long id, UpdateRequest request);
}