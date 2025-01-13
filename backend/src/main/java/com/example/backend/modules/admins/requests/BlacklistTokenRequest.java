package com.example.backend.modules.admins.requests;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class BlacklistTokenRequest {
    @NotBlank(message = "Token can not be empty!")
    private String token;
}
