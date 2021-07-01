// SPDX-License-Identifier: ISC

pragma solidity ^0.8.4;

/**
 * SC for handling payments outside of the marketplace SC.
 *
 * Provides flexibility for handling new payment methods in future.
 * Handles payments now in BNB, ADA, ETH & StableCoins.
 *
 * All prices are handles as 8-decimal irrespective of oracle source.
 */

interface IProcessPayments {
    /**
     * @dev sets the address of the oracle for the token ticker for the first time.
     *
     * Requirements:
     * `_oracleAddress` is the chainlink oracle address for price.
     * `_ticker` is the TICKER for the asset. Eg., BTC for Bitcoin.
     */
    function setOracle(address _oracleAddress, string memory _ticker)
        external
        returns (bool);

    /**
     * @dev sets the address of the contract for token ticker.
     *
     * Requirements:
     * `_ticker` is the TICKER of the asset.
     * `_contractAddress` is the address of the token smart contract.
     * `_contractAddress` should follow BEP20/ERC20 standards.
     *
     * @return bool representing the status of the transaction.
     */
    function setContract(address _contractAddress, string memory _ticker)
        external
        returns (bool);

    /**
     * @dev replace the address of the oracle for the token ticker.
     *
     * Requirements:
     * `_newOracle` is the chainlink oracle address for price.
     * `_ticker` is the TICKER for the asset. Eg., BTC for Bitcoin.
     */
    function replaceOracle(address _newOracle, string memory _ticker)
        external
        returns (bool);

    /**
     * @dev replaces the address of an existing contract for token ticker.
     *
     * Requirements:
     * `_ticker` is the TICKER of the asset.
     * `_contractAddress` is the address of the token smart contract.
     * `_contractAddress` should follow BEP20/ERC20 standards.
     *
     * @return bool representing the status of the transaction.
     */
    function replaceContract(address _newAddress, string memory _ticker)
        external
        returns (bool);

    /**
     * @dev marks a specific asset as stablecoin.
     *
     * Requirements:
     * `_ticker` - TICKER of the token that's contract address is already configured.
     *
     * @return bool representing the status of the transaction.
     */
    function markAsStablecoin(string memory _ticker) external returns (bool);

    // /**
    //  * @dev process payments for stablecoins.
    //  *
    //  * Requirements:
    //  * `_ticker` is the name of the token to be processed.
    //  * `_usd` is the amount of USD to be processed in 8-decimals.
    //  *
    //  * @return bool representing the status of payment.
    //  * uint256 representing the amount of tokens processed.
    //  */
    // function sPayment(string memory _ticker, uint256 _usd) external returns (bool, uint256);

    // /**
    //  * @dev process payments for ERC20 tokens.
    //  *
    //  * Requirements:
    //  * `_ticker` is the name of the token to be processed.
    //  * `_usd` is the amount of USD to be processed in 8-decimals.
    //  *
    //  * @return bool representing the status of payment.
    //  * uint256 representing the amount of tokens processed.
    //  */
    // function tPayment(string memory _ticker, uint256 _usd) external returns (bool, uint256);
}
