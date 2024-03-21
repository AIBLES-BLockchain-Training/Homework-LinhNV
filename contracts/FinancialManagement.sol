// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract UserManagement {
    address public admin;
    address public manager;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "You must be an admin of the contract to perform this operation");
        _;
    }

    modifier onlyManager {
        require(msg.sender == manager, "You must be a manager of the contract to perform this operation");
        _;
    }

    modifier onlyUser {
        require(msg.sender != admin && msg.sender != manager, "You must be a user of the contract to perform this operation");
        _;
    }

    function setAdmin(address newAdmin) onlyAdmin public {
        admin = newAdmin;
    }

    function setManager(address newManager) onlyAdmin public {
        manager = newManager;
    }
}

contract FinancialOperations is UserManagement {
    mapping (address => uint) public deposits;

    function deposit() payable onlyUser public {
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(deposits[msg.sender] >= amount, "Withdrawing greater than deposited amount!");
        require(address(this).balance >= amount, "Bank run :(");
        deposits[msg.sender] -= amount;
        (bool sent, bytes memory data) = msg.sender.call{ value: amount }("");
        require(sent, "Failed to send Ether");
    }
}

contract LoanSystem is FinancialOperations {

    mapping (address => LoanRequest) public loanRequests;

    struct LoanRequest {
        address loaner;
        uint amount;
        bool approved;
        bool withdrawn;
    }

    function submitLoanRequest(uint amount) public onlyUser {
        require(loanRequests[msg.sender].approved == false, "You've already got a loan active");
        require(loanRequests[msg.sender].amount == 0, "You've already submitted a loan request");
        loanRequests[msg.sender] = LoanRequest(msg.sender, amount, false, false);
    }

    function approveLoanRequest(address loanerAddress) public onlyManager {
        loanRequests[loanerAddress].approved = true;
    }

    function getLoan() public onlyUser {
        require(loanRequests[msg.sender].approved, "Your loan request is not approved yet!");
        require(address(this).balance >= loanRequests[msg.sender].amount, "No money in bank for you to get loan :(");
        require(loanRequests[msg.sender].withdrawn == false, "You've already got your loan!");
        loanRequests[msg.sender].withdrawn = true;
        (bool sent, bytes memory data) = msg.sender.call{ value: loanRequests[msg.sender].amount }("");
        require(sent, "Failed to send Ether");
    }

    function repay() payable public onlyUser {
        if (msg.value > loanRequests[msg.sender].amount) {
            uint extraAmount = msg.value - loanRequests[msg.sender].amount;
            loanRequests[msg.sender].amount = 0; // Thanks for the donation!
            (bool sent, bytes memory data) = msg.sender.call{ value: extraAmount }("");
            require(sent, "Failed to send Ether");
        } else {
            loanRequests[msg.sender].amount -= msg.value;
        }

        if (loanRequests[msg.sender].amount == 0) {
            // Resets loan status
            loanRequests[msg.sender].approved = false;
        }
    }
}