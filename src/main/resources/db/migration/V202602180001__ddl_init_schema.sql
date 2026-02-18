/* =========================================================
   EXTENSIONS
   ========================================================= */
CREATE
EXTENSION IF NOT EXISTS "uuid-ossp";


/* =========================================================
   USERS
   ========================================================= */
CREATE TABLE IF NOT EXISTS users
(
    id         UUID PRIMARY KEY      DEFAULT uuid_generate_v4(),

    email      VARCHAR(150) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    name       VARCHAR(150) NOT NULL,

    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


/* =========================================================
   ACCOUNTS
   ========================================================= */
CREATE TABLE IF NOT EXISTS accounts
(
    id         UUID PRIMARY KEY      DEFAULT uuid_generate_v4(),

    name       VARCHAR(150) NOT NULL,

    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);


/* =========================================================
   ACCOUNT_USERS (SHARING)
   ========================================================= */
CREATE TABLE IF NOT EXISTS account_users
(
    id         UUID PRIMARY KEY     DEFAULT uuid_generate_v4(),

    account_id UUID        NOT NULL,
    user_id    UUID        NOT NULL,

    role       VARCHAR(50) NOT NULL,

    created_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP,

    CONSTRAINT fk_account_users_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_account_users_user
        FOREIGN KEY (user_id)
            REFERENCES users (id)
            ON DELETE CASCADE,

    CONSTRAINT uk_account_user
        UNIQUE (account_id, user_id)
);


/* =========================================================
   PERSONS
   ========================================================= */
CREATE TABLE IF NOT EXISTS persons
(
    id          UUID PRIMARY KEY      DEFAULT uuid_generate_v4(),

    name        VARCHAR(150) NOT NULL,
    family_role VARCHAR(50),

    account_id  UUID         NOT NULL,

    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP,

    CONSTRAINT fk_persons_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE
);


/* =========================================================
   CATEGORIES
   ========================================================= */
CREATE TABLE IF NOT EXISTS categories
(
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    account_id UUID,
    name       VARCHAR(100) NOT NULL,
    type       VARCHAR(20)  NOT NULL,

    CONSTRAINT fk_categories_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE
);


/* =========================================================
   SUBCATEGORIES
   ========================================================= */
CREATE TABLE IF NOT EXISTS subcategories
(
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    category_id UUID         NOT NULL,
    name        VARCHAR(100) NOT NULL,

    CONSTRAINT fk_subcategories_category
        FOREIGN KEY (category_id)
            REFERENCES categories (id)
            ON DELETE CASCADE
);


/* =========================================================
   FIXED_EXPENSES
   ========================================================= */
CREATE TABLE IF NOT EXISTS fixed_expenses
(
    id             UUID PRIMARY KEY   DEFAULT uuid_generate_v4(),

    account_id     UUID      NOT NULL,

    description    VARCHAR(255),
    amount         NUMERIC(14, 2),

    day_of_month   INT,
    start_date     DATE,
    end_date       DATE,

    category_id    UUID,
    subcategory_id UUID,

    active         BOOLEAN,

    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP,

    CONSTRAINT fk_fixed_expenses_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_fixed_expenses_category
        FOREIGN KEY (category_id)
            REFERENCES categories (id),

    CONSTRAINT fk_fixed_expenses_subcategory
        FOREIGN KEY (subcategory_id)
            REFERENCES subcategories (id)
);


/* =========================================================
   EXPENSES
   ========================================================= */
CREATE TABLE IF NOT EXISTS expenses
(
    id               UUID PRIMARY KEY   DEFAULT uuid_generate_v4(),

    account_id       UUID      NOT NULL,

    description      VARCHAR(255),
    amount           NUMERIC(14, 2),
    date             DATE,

    category_id      UUID,
    subcategory_id   UUID,

    is_fixed         BOOLEAN,

    fixed_expense_id UUID,

    payment_method   VARCHAR(50),
    observation      VARCHAR(255),

    person_id        UUID,

    created_at       TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMP,

    CONSTRAINT fk_expenses_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_expenses_category
        FOREIGN KEY (category_id)
            REFERENCES categories (id),

    CONSTRAINT fk_expenses_subcategory
        FOREIGN KEY (subcategory_id)
            REFERENCES subcategories (id),

    CONSTRAINT fk_expenses_fixed
        FOREIGN KEY (fixed_expense_id)
            REFERENCES fixed_expenses (id),

    CONSTRAINT fk_expenses_person
        FOREIGN KEY (person_id)
            REFERENCES persons (id)
);


/* =========================================================
   INCOMES
   ========================================================= */
CREATE TABLE IF NOT EXISTS incomes
(
    id             UUID PRIMARY KEY   DEFAULT uuid_generate_v4(),

    account_id     UUID      NOT NULL,

    description    VARCHAR(255),
    amount         NUMERIC(14, 2),
    date           DATE,

    payment_method VARCHAR(50),
    observation    VARCHAR(255),

    person_id      UUID,

    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP,

    CONSTRAINT fk_incomes_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_incomes_person
        FOREIGN KEY (person_id)
            REFERENCES persons (id)
);


/* =========================================================
   PRODUCTS
   ========================================================= */
CREATE TABLE IF NOT EXISTS products
(
    id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    name           VARCHAR(255),
    barcode        VARCHAR(100) UNIQUE,

    category_id    UUID,
    subcategory_id UUID,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
            REFERENCES categories (id),

    CONSTRAINT fk_products_subcategory
        FOREIGN KEY (subcategory_id)
            REFERENCES subcategories (id)
);


/* =========================================================
   INVOICES
   ========================================================= */
CREATE TABLE IF NOT EXISTS invoices
(
    id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    account_id     UUID NOT NULL,

    external_id    VARCHAR(100),
    store_name     VARCHAR(255),
    store_document VARCHAR(50),

    total_amount   NUMERIC(14, 2),

    issue_date     TIMESTAMP,

    xml_path       VARCHAR(500),

    CONSTRAINT fk_invoices_account
        FOREIGN KEY (account_id)
            REFERENCES accounts (id)
            ON DELETE CASCADE
);


/* =========================================================
   INVOICE ITEMS
   ========================================================= */
CREATE TABLE IF NOT EXISTS invoice_items
(
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    invoice_id  UUID NOT NULL,
    product_id  UUID,

    description VARCHAR(255),

    quantity    NUMERIC(14, 3),
    unit_price  NUMERIC(14, 2),
    total_price NUMERIC(14, 2),

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id)
            REFERENCES invoices (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_invoice_items_product
        FOREIGN KEY (product_id)
            REFERENCES products (id)
);


/* =========================================================
   INDEXES (REPORT PERFORMANCE)
   ========================================================= */

CREATE INDEX IF NOT EXISTS idx_expenses_account
    ON expenses (account_id);

CREATE INDEX IF NOT EXISTS idx_expenses_date
    ON expenses (date);

CREATE INDEX IF NOT EXISTS idx_expenses_category
    ON expenses (category_id);

CREATE INDEX IF NOT EXISTS idx_incomes_account
    ON incomes (account_id);

CREATE INDEX IF NOT EXISTS idx_invoices_account
    ON invoices (account_id);