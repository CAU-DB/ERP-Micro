# ERP-Micro

A minimal ERP system implementing core business functions including:

## Features

-   Human Resources Management

    -   Employee records and department structure
    -   Position/role tracking
    -   Attendance
    -   Salary

-   Financial Management

    -   Account management
    -   Journal entries and transactions
    -   Budget
    -   Approval workflows

-   Inventory Management

    -   Product
    -   Warehouse
    -   Stock management
    -   Production

-   Sales & Purchasing
    -   Customer
    -   Order processing
    -   Payment processing
    -   Supplier

## Setup

1. Create a MySQL database named `ERP-Micro`
2. Run the schema creation scripts:

```sql
schema.sql
triggers.sql
procedures.sql
functions.sql
```

3. Load sample data:

```sql
test/data.sql
```

## Key Stored Procedures

-   `TransferEmployee` - Handles employee department/position changes
-   `CreateProject` - Creates new projects with department assignments
-   `ApproveJournal` - Processes journal entry approvals

## Key Functions

-   `CheckAccountBalanceValidity` - Validates journal entry balance
-   `GetTotalAssets` - Calculates total assets for a period
-   `GetTotalLiabilities` - Calculates total liabilities
-   `GetTotalEquity` - Calculates total equity
