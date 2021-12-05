// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    //build functions to perform safe math operations 

    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, 'Safemath addition overflow');
        return r;
    }

    function subtract(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x - y;
        require(y <= x, 'Safemath subtraction overflow');
        return r;
    }

    function multiply(uint256 x, uint256 y) internal pure returns(uint256) {
        //gas optimization
        if(x == 0) {
            return (0);
        }

        uint256 r = x * y;
        require(r /x == y, 'Safemath multiplication overflow');
        return r;
    }

    function divide(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0, 'Safemath division overflow');
        uint256 r = x / y;
        return r;
    }

    function modulo(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y != 0, 'Safemath modulo overflow');
        uint256 r = x % y;
        return r;
    }
}