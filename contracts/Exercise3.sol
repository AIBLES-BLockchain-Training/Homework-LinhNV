// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Exercise3 {
    uint public x;

    modifier increase(uint value) {
        require(value > 0, "Must increase!");
        x = x + value;
        _;
    }

    function increaseX(uint value) public increase(value) {

    }
}