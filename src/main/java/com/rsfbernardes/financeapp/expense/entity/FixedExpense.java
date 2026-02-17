package com.rsfbernardes.financeapp.expense.entity;

import com.rsfbernardes.financeapp.account.entity.Account;
import com.rsfbernardes.financeapp.category.entity.Category;
import com.rsfbernardes.financeapp.category.entity.Subcategory;
import com.rsfbernardes.financeapp.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "fixed_expenses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FixedExpense extends BaseEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    private String description;

    private BigDecimal amount;

    private Integer dayOfMonth;

    private LocalDate startDate;

    private LocalDate endDate;

    @ManyToOne
    private Category category;

    @ManyToOne
    private Subcategory subcategory;

    private Boolean active;
}
