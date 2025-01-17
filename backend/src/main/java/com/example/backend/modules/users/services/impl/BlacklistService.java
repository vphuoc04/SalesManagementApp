package com.example.backend.modules.users.services.impl;

import java.time.ZoneId;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.example.backend.modules.users.entities.BlacklistedToken;
import com.example.backend.modules.users.repositories.BlacklistedTokenRepository;
import com.example.backend.modules.users.requests.BlacklistTokenRequest;
import com.example.backend.resources.ResponseResource;
import com.example.backend.services.JwtService;

import io.jsonwebtoken.Claims;

@Service
public class BlacklistService {
    @Autowired
    private BlacklistedTokenRepository blacklistedTokenRepository;

    @Autowired 
    private JwtService jwtService;

    public Object create(BlacklistTokenRequest request) {
        if (blacklistedTokenRepository.existsByToken(request.getToken())) {
            return ResponseResource.error("TOKEN_ERROR", "Token exists in blacklist!", HttpStatus.BAD_REQUEST);
        }
        Claims claims = jwtService.getAllClaimsFromToken(request.getToken());

        Long userId = Long.valueOf(claims.getSubject());

        Date expiryDate = claims.getExpiration();
        BlacklistedToken blacklistToken = new BlacklistedToken();
        blacklistToken.setToken(request.getToken());
        blacklistToken.setUserId(userId);
        blacklistToken.setExpiryDate(expiryDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());

        blacklistedTokenRepository.save(blacklistToken);

        return ResponseResource.message("Token successfully added to token blacklist", HttpStatus.OK);

    } 
}
