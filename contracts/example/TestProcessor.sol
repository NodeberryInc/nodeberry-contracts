// SPDX-License-Identifier: ISC
pragma solidity ^0.8.7;

import "@nodeberry/solidity-payment-processor/contracts/PaymentProcessor.sol";

contract TestProcessor is PaymentProcessor {
    // Initialize Your Smart Contracts
    constructor() PaymentProcessor() {}

    function mockSale(string memory _ticker, uint256 _usd) public virtual {
        // Process Payments Equivalent in USD inside your smart contracts
        // usd should be represented in 8 decimals - 1 USD = 100000000
        payment(_ticker, "", _usd);
    }
}
