package com.example.backend.modules.admins.requests;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RefreshTokenRequest {
    @NotBlank(message = "Refresh token can not be empty")
    private String refreshToken;
}
