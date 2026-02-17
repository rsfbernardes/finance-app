package com.rsfbernardes.financeapp.account.entity;

import com.rsfbernardes.financeapp.common.entity.BaseEntity;
import com.rsfbernardes.financeapp.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "account_users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AccountUser extends BaseEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String role; // OWNER / MEMBER
}
