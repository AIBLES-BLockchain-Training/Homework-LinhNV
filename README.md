# Homework for Blockchain Course

## Description

### Financial Management

Has 3 contracts 
- UserManagement: base contract, contains utility functions for access control for 3 roles: admin, manager and user
- FinancialOperations: allows user to deposit and withdraw coin into contract, inherits UserManagement
- LoanSystem: allows user to submit a loan request to be approved by the manager, get the coin when the request is approved, and to repay the loan
