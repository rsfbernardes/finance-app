package com.rsfbernardes.financeapp.income.repository;

import com.rsfbernardes.financeapp.income.entity.Income;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IncomeRepository extends JpaRepository<Income, UUID> {
}
