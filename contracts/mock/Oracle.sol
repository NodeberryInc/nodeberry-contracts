// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../chainlink/IAggregatorV3.sol";

contract Oracle is IAggregatorV3 {
    int256 private price;

    constructor(int256 _price) {
        price = _price;
    }

    function latestRoundData()
        public
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (0, price, 0, 0, 0);
    }
}
