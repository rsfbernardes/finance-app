package com.rsfbernardes.financeapp.invoice.repository;

import com.rsfbernardes.financeapp.invoice.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface InvoiceRepository extends JpaRepository<Invoice, UUID> {
}
