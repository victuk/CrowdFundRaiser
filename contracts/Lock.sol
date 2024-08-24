// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";

contract Lock {
    function areaOfATriangle(
        uint base,
        uint height
    ) public pure returns (uint) {
        return (base * height) / 2;
    }

    function areaOfASquare(uint lengthofOneSide) public pure returns (uint) {
        return lengthofOneSide * lengthofOneSide;
    }

    function areaOfARectangle(
        uint length,
        uint width
    ) public pure returns (uint) {
        return length * width;
    }

    function loopIt() public pure returns (uint) {
        for(uint i = 1; i <= 10; i++) {
            console.log(i);
        }
        return 0;
    }


}
