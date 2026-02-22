package com.rsfbernardes.financeapp.category.repository;

import com.rsfbernardes.financeapp.category.entity.Subcategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface SubcategoryRepository extends JpaRepository<Subcategory, UUID> {
}
