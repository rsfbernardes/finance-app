package com.rsfbernardes.financeapp.product.entity;

import com.rsfbernardes.financeapp.category.entity.Category;
import com.rsfbernardes.financeapp.category.entity.Subcategory;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {

    @Id
    @GeneratedValue
    private UUID id;

    private String name;

    private String barcode;

    @ManyToOne
    private Category category;

    @ManyToOne
    private Subcategory subcategory;
}
