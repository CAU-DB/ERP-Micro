USE `ERP-Micro`;

DELIMITER //

DROP FUNCTION IF EXISTS CheckAccountBalanceValidity//
CREATE FUNCTION CheckAccountBalanceValidity(
    p_journal_ID VARCHAR(7)
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE debit_sum DECIMAL(10,2);
    DECLARE credit_sum DECIMAL(10,2);

    IF p_journal_ID IS NULL THEN
        RETURN FALSE;
    END IF;
    
    SELECT total_debit, total_credit
    INTO debit_sum, credit_sum
    FROM journal
    WHERE journal_ID = p_journal_ID;
    
    RETURN COALESCE(debit_sum = credit_sum, FALSE);
END //


-- SoFP functions
DROP FUNCTION IF EXISTS GetTotalAssets//
CREATE FUNCTION GetTotalAssets(
    p_account_period_ID VARCHAR(7)
) RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total_assets DECIMAL(15,2);
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    
    SELECT start_date, end_date
    INTO v_start_date, v_end_date
    FROM account_period
    WHERE account_period_ID = p_account_period_ID;
    
    -- Calculate total assets
    SELECT COALESCE(SUM(
        CASE 
            WHEN a.debit_credit_indicator = 'Debit' THEN t.debit - t.credit
            ELSE t.credit - t.debit
        END
    ), 0) INTO total_assets
    FROM account AS a
    JOIN transaction AS t USING(account_code)
    WHERE a.account_type = 'Assets'
        AND a.is_active = 1
        AND t.trans_date BETWEEN v_start_date AND v_end_date;
    
    RETURN total_assets;
END //

DROP FUNCTION IF EXISTS GetTotalLiabilities//
CREATE FUNCTION GetTotalLiabilities(
    p_account_period_ID VARCHAR(7)
) RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total_liabilities DECIMAL(15,2);
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    
    SELECT start_date, end_date 
    INTO v_start_date, v_end_date
    FROM account_period 
    WHERE account_period_ID = p_account_period_ID;
    
    SELECT COALESCE(SUM(
        CASE 
            WHEN a.debit_credit_indicator = 'Credit' THEN t.credit - t.debit
            ELSE t.debit - t.credit
        END
    ), 0) INTO total_liabilities
    FROM account AS a
    JOIN transaction AS t USING(account_code)
    WHERE a.account_type = 'Liabilities'
    AND a.is_active = 1
    AND t.trans_date BETWEEN v_start_date AND v_end_date;
    
    RETURN total_liabilities;
END //

DROP FUNCTION IF EXISTS GetTotalEquity//
CREATE FUNCTION GetTotalEquity(
    p_account_period_ID VARCHAR(7)
) RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total_equity DECIMAL(15,2);
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    
    SELECT start_date, end_date 
    INTO v_start_date, v_end_date
    FROM account_period 
    WHERE account_period_ID = p_account_period_ID;
    
    SELECT COALESCE(SUM(
        CASE 
            WHEN a.debit_credit_indicator = 'Credit' THEN t.credit - t.debit
            ELSE t.debit - t.credit
        END
    ), 0) INTO total_equity
    FROM account a
    JOIN transaction AS t USING(account_code)
    WHERE a.account_type = 'Equity'
    AND a.is_active = 1
    AND t.trans_date BETWEEN v_start_date AND v_end_date;
    
    RETURN total_equity;
END //

DELIMITER ;