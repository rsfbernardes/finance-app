package com.rsfbernardes.financeapp.expense.repository;

import com.rsfbernardes.financeapp.expense.entity.Expense;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ExpenseRepository extends JpaRepository<Expense, UUID> {
}
