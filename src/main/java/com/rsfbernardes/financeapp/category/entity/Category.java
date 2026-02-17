package com.rsfbernardes.financeapp.category.entity;

import com.rsfbernardes.financeapp.account.entity.Account;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Category {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type; // INCOME / EXPENSE
}
