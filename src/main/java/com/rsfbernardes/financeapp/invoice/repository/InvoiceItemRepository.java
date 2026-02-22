package com.rsfbernardes.financeapp.invoice.repository;

import com.rsfbernardes.financeapp.invoice.entity.InvoiceItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface InvoiceItemRepository extends JpaRepository<InvoiceItem, UUID> {
}
