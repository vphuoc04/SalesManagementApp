package com.example.backend.databases.seeders;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.admins.entities.Admin;
import com.example.backend.modules.admins.repositories.AdminRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DatabaseSeeder implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseSeeder.class);

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AdminRepository adminRepository;

    @Transactional
    @Override
    public void run (String... args) throws Exception {
        logger.info("Seeding database...");

        if (isTableEmpty()) {
            String passwordEncode = passwordEncoder.encode("password");
            
            Admin admin = new Admin();
            admin.setFirstName("Phước");
            admin.setMiddleName("Văn");
            admin.setLastName("Đoàn");
            admin.setEmail("vphuoc2409@gmail.com");
            admin.setPassword(passwordEncode);
            admin.setPhone("0123456789");
            admin.setImage(null);

            adminRepository.save(admin);
        }
    }

    private boolean isTableEmpty() {
        Long count = (Long) entityManager.createQuery("SELECT COUNT(id) FROM Admin").getSingleResult();
        return count == 0;
    }
}
