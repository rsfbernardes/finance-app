-- ===============================
-- EXTENSIONS
-- ===============================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===============================
-- USERS
-- ===============================
CREATE TABLE users (
                       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       name VARCHAR(255) NOT NULL,

                       created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMP
);

-- ===============================
-- ACCOUNTS
-- ===============================
CREATE TABLE accounts (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                          name VARCHAR(255) NOT NULL,

                          created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMP
);

-- ===============================
-- ACCOUNT_USERS (SHARING)
-- ===============================
CREATE TABLE account_users (
                               id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                               account_id UUID NOT NULL,
                               user_id UUID NOT NULL,
                               role VARCHAR(20) NOT NULL,

                               created_at TIMESTAMP NOT NULL DEFAULT NOW(),

                               CONSTRAINT fk_account_users_account
                                   FOREIGN KEY (account_id)
                                       REFERENCES accounts(id)
                                       ON DELETE CASCADE,

                               CONSTRAINT fk_account_users_user
                                   FOREIGN KEY (user_id)
                                       REFERENCES users(id)
                                       ON DELETE CASCADE,

                               CONSTRAINT uk_account_user UNIQUE (account_id, user_id)
);

-- ===============================
-- CATEGORIES
-- ===============================
CREATE TABLE categories (
                            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                            account_id UUID,
                            name VARCHAR(150) NOT NULL,
                            type VARCHAR(20) NOT NULL, -- INCOME / EXPENSE

                            created_at TIMESTAMP NOT NULL DEFAULT NOW(),

                            CONSTRAINT fk_category_account
                                FOREIGN KEY (account_id)
                                    REFERENCES accounts(id)
                                    ON DELETE CASCADE
);

-- ===============================
-- SUBCATEGORIES
-- ===============================
CREATE TABLE subcategories (
                               id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                               category_id UUID NOT NULL,
                               name VARCHAR(150) NOT NULL,

                               created_at TIMESTAMP NOT NULL DEFAULT NOW(),

                               CONSTRAINT fk_subcategory_category
                                   FOREIGN KEY (category_id)
                                       REFERENCES categories(id)
                                       ON DELETE CASCADE
);

-- ===============================
-- INCOMES
-- ===============================
CREATE TABLE incomes (
                         id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                         account_id UUID NOT NULL,

                         description VARCHAR(255) NOT NULL,
                         amount NUMERIC(14,2) NOT NULL,
                         date DATE NOT NULL,

                         owner_name VARCHAR(150),
                         payment_method VARCHAR(50),
                         observation TEXT,

                         created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                         updated_at TIMESTAMP,

                         CONSTRAINT fk_income_account
                             FOREIGN KEY (account_id)
                                 REFERENCES accounts(id)
                                 ON DELETE CASCADE
);

-- ===============================
-- FIXED EXPENSES
-- ===============================
CREATE TABLE fixed_expenses (
                                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                                account_id UUID NOT NULL,

                                description VARCHAR(255) NOT NULL,
                                amount NUMERIC(14,2) NOT NULL,

                                day_of_month INT NOT NULL,

                                start_date DATE,
                                end_date DATE,

                                category_id UUID,
                                subcategory_id UUID,

                                active BOOLEAN DEFAULT TRUE,

                                created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                                updated_at TIMESTAMP,

                                CONSTRAINT fk_fixed_expense_account
                                    FOREIGN KEY (account_id)
                                        REFERENCES accounts(id)
                                        ON DELETE CASCADE,

                                CONSTRAINT fk_fixed_expense_category
                                    FOREIGN KEY (category_id)
                                        REFERENCES categories(id),

                                CONSTRAINT fk_fixed_expense_subcategory
                                    FOREIGN KEY (subcategory_id)
                                        REFERENCES subcategories(id)
);

-- ===============================
-- EXPENSES
-- ===============================
CREATE TABLE expenses (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                          account_id UUID NOT NULL,

                          description VARCHAR(255) NOT NULL,
                          amount NUMERIC(14,2) NOT NULL,
                          date DATE NOT NULL,

                          category_id UUID NOT NULL,
                          subcategory_id UUID,

                          is_fixed BOOLEAN DEFAULT FALSE,
                          fixed_expense_id UUID,

                          payment_method VARCHAR(50),
                          observation TEXT,

                          created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMP,

                          CONSTRAINT fk_expense_account
                              FOREIGN KEY (account_id)
                                  REFERENCES accounts(id)
                                  ON DELETE CASCADE,

                          CONSTRAINT fk_expense_category
                              FOREIGN KEY (category_id)
                                  REFERENCES categories(id),

                          CONSTRAINT fk_expense_subcategory
                              FOREIGN KEY (subcategory_id)
                                  REFERENCES subcategories(id),

                          CONSTRAINT fk_expense_fixed
                              FOREIGN KEY (fixed_expense_id)
                                  REFERENCES fixed_expenses(id)
);

-- ===============================
-- INVOICES (NFC-e)
-- ===============================
CREATE TABLE invoices (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                          account_id UUID NOT NULL,

                          external_id VARCHAR(100),
                          store_name VARCHAR(255),
                          store_document VARCHAR(50),

                          total_amount NUMERIC(14,2),
                          issue_date TIMESTAMP,

                          xml_path TEXT,

                          created_at TIMESTAMP NOT NULL DEFAULT NOW(),

                          CONSTRAINT fk_invoice_account
                              FOREIGN KEY (account_id)
                                  REFERENCES accounts(id)
                                  ON DELETE CASCADE
);

-- ===============================
-- PRODUCTS
-- ===============================
CREATE TABLE products (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                          name VARCHAR(255) NOT NULL,
                          barcode VARCHAR(100),

                          category_id UUID,
                          subcategory_id UUID,

                          created_at TIMESTAMP NOT NULL DEFAULT NOW(),

                          CONSTRAINT fk_product_category
                              FOREIGN KEY (category_id)
                                  REFERENCES categories(id),

                          CONSTRAINT fk_product_subcategory
                              FOREIGN KEY (subcategory_id)
                                  REFERENCES subcategories(id)
);

-- ===============================
-- INVOICE ITEMS
-- ===============================
CREATE TABLE invoice_items (
                               id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

                               invoice_id UUID NOT NULL,
                               product_id UUID,

                               description VARCHAR(255),
                               quantity NUMERIC(14,3),
                               unit_price NUMERIC(14,2),
                               total_price NUMERIC(14,2),

                               CONSTRAINT fk_invoice_item_invoice
                                   FOREIGN KEY (invoice_id)
                                       REFERENCES invoices(id)
                                       ON DELETE CASCADE,

                               CONSTRAINT fk_invoice_item_product
                                   FOREIGN KEY (product_id)
                                       REFERENCES products(id)
);

-- ===============================
-- INDEXES (REPORT PERFORMANCE)
-- ===============================
CREATE INDEX idx_expense_account_date
    ON expenses(account_id, date);

CREATE INDEX idx_expense_category
    ON expenses(category_id);

CREATE INDEX idx_expense_subcategory
    ON expenses(subcategory_id);

CREATE INDEX idx_income_account_date
    ON incomes(account_id, date);

CREATE INDEX idx_invoice_account_date
    ON invoices(account_id, issue_date);
