package com.rsfbernardes.financeapp.person.repository;

import com.rsfbernardes.financeapp.person.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PersonRepository extends JpaRepository<Person, UUID> {
}
