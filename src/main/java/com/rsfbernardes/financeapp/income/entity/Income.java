package com.rsfbernardes.financeapp.income.entity;

import com.rsfbernardes.financeapp.account.entity.Account;
import com.rsfbernardes.financeapp.common.entity.BaseEntity;
import com.rsfbernardes.financeapp.person.entity.Person;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "incomes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Income extends BaseEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    private String description;

    private BigDecimal amount;

    private LocalDate date;

    private String paymentMethod;

    private String observation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "person_id")
    private Person person;

}
