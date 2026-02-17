package com.rsfbernardes.financeapp.invoice.entity;

import com.rsfbernardes.financeapp.account.entity.Account;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "invoices")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    private String externalId;

    private String storeName;

    private String storeDocument;

    private BigDecimal totalAmount;

    private LocalDateTime issueDate;

    private String xmlPath;
}
