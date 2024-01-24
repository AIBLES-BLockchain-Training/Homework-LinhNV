// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Exercise2 {
    int public x = 0;

    function addToX2(int y) public {
        x = x + y;
    }
}