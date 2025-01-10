package com.example.backend.modules.admins.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AdminResource {
    private final Long id;
    private final String email;
    private final String firstName;
    private final String lastName;
    private final String middleName;
    private final String phone;
}
