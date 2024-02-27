// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract NumberManager {

    uint private totalSum;
    uint public lastAddedNumber;

    constructor(uint initialTotalSum) {
        totalSum = initialTotalSum;
        lastAddedNumber = 0;
    }

    function addNumber(uint number) public {
        incrementTotalSum(number);
        setLastAddedNumber(number);
    }

    function subtractNumber(uint number) public {
        decrementTotalSum(number);
        setLastAddedNumber(number);
    }

    function getTotalSum() external view returns(uint) {
        return totalSum;
    }

    function incrementTotalSum(uint number) private {
        totalSum += number;
    }

    function decrementTotalSum(uint number) private {
        totalSum -= number;
    }

    function setLastAddedNumber(uint number) internal {
        lastAddedNumber = number;
    }
}