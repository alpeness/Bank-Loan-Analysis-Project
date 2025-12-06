-- 1. Customers Table
CREATE TABLE IF NOT EXISTS customers(
    customer_id VARCHAR(100) PRIMARY KEY,
    annual_income DECIMAL(15, 2),
    years_in_current_job VARCHAR(50),
    home_ownership VARCHAR(50)
);

-- 2. Loans Table
CREATE TABLE IF NOT EXISTS loans(
    loan_id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100),
    current_loan_amount DECIMAL(15, 2),
    term VARCHAR(50),
    purpose VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

-- 3. Credit Profiles Table
CREATE TABLE IF NOT EXISTS credit_profiles(
    customer_id VARCHAR(100) PRIMARY KEY,
    credit_score INT,
    monthly_debt DECIMAL(15, 2),
    years_of_credit_history DECIMAL(5, 1),
    months_since_last_delinquent INT,
    number_of_open_accounts INT,
    number_of_credit_problems INT,
    current_credit_balance DECIMAL(15, 2),
    maximum_open_credit DECIMAL(15, 2),
    bankruptcies INT,
    tax_liens INT,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);


-- Temporary Table to importing data
CREATE TABLE IF NOT EXISTS raw_credit_data (
    loan_id VARCHAR(50),
    customer_id VARCHAR(50),
    current_loan_amount DECIMAL(15,2),
    term VARCHAR(20),
    credit_score INT,
    annual_income DECIMAL(15,2),
    years_in_current_job VARCHAR(20),
    home_ownership VARCHAR(20),
    purpose VARCHAR(50),
    monthly_debt DECIMAL(15,2),
    years_of_credit_history INT,
    months_since_last_delinquent INT,
    number_of_open_accounts INT,
    number_of_credit_problems INT,
    current_credit_balance DECIMAL(15,2),
    maximum_open_credit DECIMAL(15,2),
    bankruptcies INT,
    tax_liens INT
);

-- Inserting data that we cleaned with Excel to tables that we normalized (customers, loans, credit_profiles) --

-- Customers
INSERT IGNORE INTO customers (
    customer_id,
    annual_income,
    years_in_current_job,
    home_ownership
)
SELECT DISTINCT
    customer_id,
    annual_income,
    years_in_current_job,
    home_ownership
FROM raw_credit_data
WHERE customer_id IS NOT NULL;

-- Loans
INSERT IGNORE INTO loans (
    loan_id,
    customer_id,
    current_loan_amount,
    term,
    purpose
)
SELECT
    loan_id,
    customer_id,
    current_loan_amount,
    term,
    purpose
FROM raw_credit_data
WHERE loan_id IS NOT NULL;

-- Credit Profiles
INSERT IGNORE INTO credit_profiles (
    customer_id,
    credit_score,
    monthly_debt,
    years_of_credit_history,
    months_since_last_delinquent,
    number_of_open_accounts,
    number_of_credit_problems,
    current_credit_balance,
    maximum_open_credit,
    bankruptcies,
    tax_liens
)
SELECT DISTINCT
    customer_id,
    credit_score,
    monthly_debt,
    years_of_credit_history,
    months_since_last_delinquent,
    number_of_open_accounts,
    number_of_credit_problems,
    current_credit_balance,
    maximum_open_credit,
    bankruptcies,
    tax_liens
FROM raw_credit_data
WHERE customer_id IS NOT NULL;

-- How many customers are there in customers table?
SELECT COUNT(DISTINCT customer_id) as total_customer FROM customers;

-- How many loans are there in loans table?
SELECT COUNT(*) as total_loans FROM loans;

-- How many profiles are there in credit_profiles table?
SELECT COUNT(*) as total_profile FROM credit_profiles;