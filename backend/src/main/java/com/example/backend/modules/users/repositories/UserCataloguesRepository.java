package com.example.backend.modules.users.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.backend.modules.users.entities.UserCatalogues;

@Repository
public interface UserCataloguesRepository extends JpaRepository<UserCatalogues, Long> {

}
