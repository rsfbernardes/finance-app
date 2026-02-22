package com.rsfbernardes.financeapp.expense.repository;

import com.rsfbernardes.financeapp.expense.entity.FixedExpense;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface FixedExpenseRepository extends JpaRepository<FixedExpense, UUID> {
}
