package com.example.backend.modules.users.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.RefreshToken;
import com.example.backend.modules.users.repositories.RefreshTokenRepository;
import com.example.backend.modules.users.requests.BlacklistTokenRequest;
import com.example.backend.modules.users.requests.LoginRequest;
import com.example.backend.modules.users.requests.RefreshTokenRequest;
import com.example.backend.modules.users.resources.LoginResource;
import com.example.backend.modules.users.resources.RefreshTokenResource;
import com.example.backend.modules.users.services.impl.BlacklistService;
import com.example.backend.modules.users.services.interfaces.UserServiceInterface;
import com.example.backend.resources.MessageResourece;
import com.example.backend.resources.ResponseResource;
import com.example.backend.services.JwtService;

import jakarta.validation.Valid;

@Validated
@RestController
@RequestMapping("api/v1/auth")
public class AuthController {
    private final UserServiceInterface userService;

    @Autowired
    private BlacklistService blacklistService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    public AuthController(
        UserServiceInterface userService
    ){
        this.userService = userService;
    }

    @PostMapping("login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        Object result = userService.authenticate(request);

        if(result instanceof LoginResource loginResource) {
            return ResponseEntity.ok(loginResource);
        }

        if(result instanceof ResponseResource responseResource) {
            return ResponseEntity.unprocessableEntity().body(responseResource);
        }

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Network errors");
    }

    @PostMapping("blacklisted_tokens")
    public ResponseEntity<?> addTokenToBlacklist(@Valid @RequestBody BlacklistTokenRequest request) {
        try {
            Object result = blacklistService.create(request);

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(new MessageResourece("Network error!"));
        }
    }

    @GetMapping("logout")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            
            BlacklistTokenRequest request = new BlacklistTokenRequest();
            request.setToken(token);

            Object message = blacklistService.create(request);
            return ResponseEntity.ok(message);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(new MessageResourece("Network error!"));
        }
    }

    @PostMapping("refresh")
    public ResponseEntity<?> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        String refreshToken = request.getRefreshToken();

        if(!jwtService.isRefreshTokenValid(refreshToken)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new MessageResourece("Refresh token is invalid!"));
        }

        Optional<RefreshToken> dbRefreshTokenOptional = refreshTokenRepository.findByRefreshToken(refreshToken);

        if(dbRefreshTokenOptional.isPresent()) {
            RefreshToken dbRefreshToken = dbRefreshTokenOptional.get();
            Long userId = dbRefreshToken.getUserId();
            String email = dbRefreshToken.getUser().getEmail();

            String newToken = jwtService.generateToken(userId, email);
            String newRefreshToken = jwtService.generateRefreshToken(userId, email);

            return ResponseEntity.ok(new RefreshTokenResource(newToken, newRefreshToken));
        }
        return ResponseEntity.internalServerError().body(new MessageResourece("Network error!"));
    } 
}
