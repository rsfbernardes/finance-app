package com.rsfbernardes.financeapp.invoice.entity;

import com.rsfbernardes.financeapp.product.entity.Product;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "invoice_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceItem {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "invoice_id", nullable = false)
    private Invoice invoice;

    @ManyToOne
    private Product product;

    private String description;

    private BigDecimal quantity;

    private BigDecimal unitPrice;

    private BigDecimal totalPrice;
}
