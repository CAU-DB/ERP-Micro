-- Test TransferEmployee procedure
CALL TransferEmployee('EM00052', 'DE00702', '팀원', '2025-01-01');

SELECT * FROM employee WHERE employee_ID = 'EM00052';
SELECT * FROM position_history WHERE employee_ID = 'EM00052' ORDER BY start_date DESC;


-- Test CreateProject procedure
CALL CreateProject('Test Project', '2024-01-01', '2024-12-31', 'DE00001,DE00002,DE00003');

SELECT p.project_name, GROUP_CONCAT(d.dept_name) as departments
FROM project p
JOIN participation pt ON p.project_ID = pt.project_ID
JOIN departments d ON pt.dept_ID = d.dept_ID
WHERE p.project_name = 'Test Project'
GROUP BY p.project_name;


-- Test ApproveJournal procedure
CALL ApproveJournal('J10291', 'EM00010');

SELECT * FROM journal WHERE journal_ID = 'J10291';
SELECT * FROM approval WHERE journal_ID = 'J10291';


-- Test CheckAccountBalanceValidity function
INSERT INTO journal (journal_ID, total_debit, total_credit, dept_ID, is_approved)
VALUES
('JT0001', 1000.00, 1000.00, 'DE00001', 0),  -- Balanced
('JT0002', 1500.00, 1200.00, 'DE00001', 0);  -- Unbalanced

SELECT 'Balanced Journal' AS test_case,
    IF(CheckAccountBalanceValidity('JT0001') = TRUE, 'PASS', 'FAIL') AS result
UNION ALL
SELECT 'Unbalanced Journal',
    IF(CheckAccountBalanceValidity('JT0002') = FALSE, 'PASS', 'FAIL')
UNION ALL
SELECT 'NULL Journal ID',
    IF(CheckAccountBalanceValidity(NULL) = FALSE, 'PASS', 'FAIL')
UNION ALL
SELECT 'Non-existent Journal',
    IF(CheckAccountBalanceValidity('INVALID') = FALSE, 'PASS', 'FAIL');

-- Cleanup
DELETE FROM journal WHERE journal_ID IN ('JT0001', 'JT0002');


-- Test SoFP functions
SELECT GetTotalAssets('AP00004') as total_assets,
       GetTotalLiabilities('AP00004') as total_liabilities,
       GetTotalEquity('AP00004') as total_equity;