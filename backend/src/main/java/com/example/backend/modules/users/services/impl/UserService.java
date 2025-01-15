package com.example.backend.modules.users.services.impl;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.backend.databases.seeders.DatabaseSeeder;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.requests.LoginRequest;
import com.example.backend.modules.users.resources.UserResource;
import com.example.backend.modules.users.resources.LoginResource;
import com.example.backend.modules.users.services.interfaces.UserServiceInterface;
import com.example.backend.resources.ResponseResource;
import com.example.backend.services.BaseService;
import com.example.backend.services.JwtService;

@Service
public class UserService extends BaseService implements UserServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseSeeder.class);

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncode;

    @Autowired
    private UserRepository userRepository;

    @Override
    public Object authenticate(LoginRequest request) {
        try {
            User user = userRepository.findByEmail(request.getEmail()).orElseThrow(() -> new BadCredentialsException("Incorrect email or password!"));

            if(!passwordEncode.matches(request.getPassword(), user.getPassword())) {
                throw new BadCredentialsException("Incorrect email or password!");
            }

            UserResource userResource = UserResource.builder()
                .id(user.getId())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .middleName(user.getMiddleName())
                .lastName(user.getLastName())
                .phone(user.getPhone())
                .build();
            
            String token = jwtService.generateToken(user.getId(), user.getEmail());
            String refreshToken = jwtService.generateRefreshToken(user.getId(), user.getEmail());

            return new LoginResource(token, refreshToken, userResource);
        } catch (BadCredentialsException e) {
            logger.error("Authentication error: " + e.getMessage());
            Map<String, String> errors = new HashMap<>();
            errors.put("Message: ", e.getMessage());
            ResponseResource responseResource = new ResponseResource("Error: ", errors);

            return responseResource;
        }
    }
}
