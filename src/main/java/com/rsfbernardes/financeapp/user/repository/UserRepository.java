package com.rsfbernardes.financeapp.user.repository;

import com.rsfbernardes.financeapp.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
}
