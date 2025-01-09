package com.example.backend.modules.admins.services.impl;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.backend.modules.admins.entities.Admin;
import com.example.backend.modules.admins.repositories.AdminRepository;

import org.springframework.security.core.userdetails.UserDetailsService;

import lombok.RequiredArgsConstructor;

import java.util.Collections;

@RequiredArgsConstructor
@Service
public class CustomAdminDetailsService implements UserDetailsService {
    private final AdminRepository adminRepository;

    @Override
    public UserDetails loadUserByUsername(String adminId) throws UsernameNotFoundException {
        Admin admin = adminRepository.findById(Long.valueOf(adminId)).orElseThrow(
            () -> new UsernameNotFoundException("Admin not found!")
        );

        return new org.springframework.security.core.userdetails.User(
            admin.getEmail(), 
            admin.getPassword(), 
            Collections.emptyList()
        );
    }
}
