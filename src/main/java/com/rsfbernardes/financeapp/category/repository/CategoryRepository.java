package com.rsfbernardes.financeapp.category.repository;

import com.rsfbernardes.financeapp.category.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface CategoryRepository extends JpaRepository<Category, UUID> {
}
