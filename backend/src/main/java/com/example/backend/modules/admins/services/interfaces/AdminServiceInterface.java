package com.example.backend.modules.admins.services.interfaces;

import com.example.backend.modules.admins.requests.LoginRequest;

public interface AdminServiceInterface {
    Object authenticate(LoginRequest request);
}
