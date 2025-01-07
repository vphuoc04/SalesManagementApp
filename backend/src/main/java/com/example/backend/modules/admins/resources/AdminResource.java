package com.example.backend.modules.admins.resources;

public class AdminResource {
    private final Long id;
    private final String email;
    private final String firstName;
    private final String lastName;
    private final String middleName;
    private final String phone;

    public AdminResource (
        Long id,
        String email,
        String firstName,
        String lastName,
        String middleName,
        String phone
    ){
        this.id = id;
        this.email = email;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.phone = phone;
    }

    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getPhone() {
        return phone;
    }
}
