package com.rsfbernardes.financeapp.account.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AccountUser extends JpaRepository<AccountUser, UUID> {
}
