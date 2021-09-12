// SPDX-License-Identifier: ISC
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interface/IPaymentProcessor.sol";
import "./chainlink/IAggregatorV3.sol";

/**
 * Implementation of {IPaymentProcessor}
 */

contract PaymentProcessor is IPaymentProcessor, Ownable {
    mapping(bytes => address) private oracleAddress;
    mapping(bytes => address) private contractAddress;
    mapping(bytes => uint8) private isStableCoin;

    event Payment(
        address indexed from,
        address indexed merchant,
        uint256 amount,
        string token,
        string notes
    );

    modifier Available(string memory _ticker) {
        require(
            contractAddress[bytes(_ticker)] != address(0),
            "error: token not available"
        );
        _;
    }

    modifier Stablecoin(string memory _ticker) {
        require(
            isStableCoin[bytes(_ticker)] == 1,
            "error: token not stablecoin"
        );
        _;
    }

    constructor() Ownable() {}

    function setOracle(address _oracleAddress, string memory _ticker)
        public
        virtual
        override
        onlyOwner
        returns (bool)
    {
        require(
            _oracleAddress != address(0),
            "PoS Error: oracle cannot be a zero address"
        );
        bytes memory ticker = bytes(_ticker);

        if (oracleAddress[ticker] == address(0)) {
            oracleAddress[ticker] = _oracleAddress;
            return true;
        } else {
            revert("PoS Error: oracle address already found");
        }
    }

    function setContract(address _contractAddress, string memory _ticker)
        public
        virtual
        override
        onlyOwner
        returns (bool)
    {
        require(
            _contractAddress != address(0),
            "PoS Error: contract cannot be a zero address"
        );
        bytes memory ticker = bytes(_ticker);

        if (contractAddress[ticker] == address(0)) {
            contractAddress[ticker] = _contractAddress;
            return true;
        } else {
            revert("PoS Error: contract already initialized.");
        }
    }

    function replaceOracle(address _newOracle, string memory _ticker)
        public
        virtual
        override
        onlyOwner
        returns (bool)
    {
        require(
            _newOracle != address(0),
            "PoS Error: oracle cannot be a zero address"
        );
        bytes memory ticker = bytes(_ticker);

        if (oracleAddress[ticker] != address(0)) {
            oracleAddress[ticker] = _newOracle;
            return true;
        } else {
            revert("PoS Error: set oracle to replace.");
        }
    }

    function replaceContract(address _newAddress, string memory _ticker)
        public
        virtual
        override
        onlyOwner
        returns (bool)
    {
        require(
            _newAddress != address(0),
            "PoS Error: contract cannot be a zero address"
        );
        bytes memory ticker = bytes(_ticker);

        if (contractAddress[ticker] != address(0)) {
            contractAddress[ticker] = _newAddress;
            return true;
        } else {
            revert("PoS Error: contract not initialized yet.");
        }
    }

    function markAsStablecoin(string memory _ticker)
        public
        virtual
        override
        Available(_ticker)
        onlyOwner
        returns (bool)
    {
        isStableCoin[bytes(_ticker)] = 1;
        return true;
    }

    function payment(
        string memory _ticker,
        string memory _notes,
        uint256 _usd
    ) internal virtual returns (bool, uint256) {
        if (isStableCoin[bytes(_ticker)] == 1) {
            return sPayment(address(this), _ticker, _usd, _notes);
        } else {
            return tPayment(address(this), _ticker, _usd, _notes);
        }
    }

    function sPayment(
        address _merchant,
        string memory _ticker,
        uint256 _usd,
        string memory _notes
    )
        internal
        virtual
        Available(_ticker)
        Stablecoin(_ticker)
        returns (bool, uint256)
    {
        uint256 tokens = sAmount(_ticker, _usd);
        address spender = _msgSender();
        address tokenAddress = contractAddress[bytes(_ticker)];
        require(
            fetchApproval(_ticker, spender) >= tokens,
            "PoS Error: insufficient allowance for spender"
        );
        emit Payment(spender, _merchant, tokens, _ticker, _notes);
        return (
            IERC20(tokenAddress).transferFrom(spender, _merchant, tokens),
            tokens
        );
    }

    function sAmount(string memory _ticker, uint256 _usd)
        public
        view
        virtual
        returns (uint256)
    {
        address tokenAddress = contractAddress[bytes(_ticker)];
        uint256 decimals = IERC20Metadata(tokenAddress).decimals();
        if (decimals > 8) {
            return _usd * 10**(decimals - 8);
        } else {
            return _usd / 10**(8 - decimals);
        }
    }

    function tPayment(
        address _merchant,
        string memory _ticker,
        uint256 _usd,
        string memory _notes
    ) internal virtual Available(_ticker) returns (bool, uint256) {
        uint256 amount = tAmount(_ticker, _usd);
        address user = _msgSender();

        require(
            fetchApproval(_ticker, user) >= amount,
            "PoS Error: Insufficient Approval"
        );
        address tokenAddress = contractAddress[bytes(_ticker)];
        emit Payment(user, _merchant, amount, _ticker, _notes);
        return (
            IERC20(tokenAddress).transferFrom(user, _merchant, amount),
            amount
        );
    }

    function fetchApproval(string memory _ticker, address _holder)
        public
        view
        returns (uint256)
    {
        address tokenAddress = contractAddress[bytes(_ticker)];
        return IERC20(tokenAddress).allowance(_holder, address(this));
    }

    function tAmount(string memory _ticker, uint256 _usd)
        public
        view
        returns (uint256)
    {
        uint256 value = _usd * 10**18;
        uint256 price = fetchOraclePrice(_ticker);

        address tokenAddress = contractAddress[bytes(_ticker)];
        uint256 decimal = IERC20Metadata(tokenAddress).decimals();

        require(decimal <= 18, "PoS Error: asset class cannot be supported");
        uint256 decimalCorrection = 18 - decimal;

        uint256 tokensAmount = value / price;
        return tokensAmount / 10**decimalCorrection;
    }

    function fetchContract(string memory _ticker)
        public
        view
        returns (address)
    {
        return contractAddress[bytes(_ticker)];
    }

    function fetchOracle(string memory _ticker) public view returns (address) {
        return oracleAddress[bytes(_ticker)];
    }

    function fetchOraclePrice(string memory _ticker)
        public
        view
        returns (uint256)
    {
        address oracle = oracleAddress[bytes(_ticker)];
        (, int256 price, , , ) = IAggregatorV3(oracle).latestRoundData();
        return uint256(price);
    }
}
