// SPDX-License-Identifier: ISC
pragma solidity ^0.8.4;

import "./interface/IMerchant.sol";
import "./utils/Context.sol";

contract Merchant is IMerchant, Context {
    struct Info {
        address id;
        bytes infohash;
        bytes pointer;
    }

    mapping(address => Info) private _merchant;
    mapping(bytes => bool) private _available;
    mapping(address => bool) private _registered;
    mapping(bytes => address) private _pointerAddress;

    event CreateMerchant(
        address indexed merchant,
        bytes infohash,
        bytes pointer
    );

    modifier Available(bytes memory _pointer) {
        require(
            !_available[_pointer],
            "Merchant Error: pointer already claimed"
        );
        _;
    }

    modifier Registered() {
        require(
            !_registered[_msgSender()],
            "Merchant Error: merchant already registered"
        );
        _;
    }

    function register(string memory _pointer, string memory _hash)
        public
        virtual
        override
        Available(bytes(_pointer))
        Registered
        returns (bool)
    {
        bytes memory pointer = bytes(_pointer);
        bytes memory hash = bytes(_hash);

        _available[pointer] = true;
        _registered[_msgSender()] = true;
        _merchant[_msgSender()] = Info(_msgSender(), hash, pointer);
        _pointerAddress[pointer] = _msgSender();

        emit CreateMerchant(_msgSender(), hash, pointer);
        return true;
    }

    function merchantInfo(address _query)
        public
        view
        override
        returns (
            address,
            bytes memory,
            bytes memory
        )
    {
        require(_registered[_query], "Merchant Error: merchant not found");
        Info storage m = _merchant[_query];
        return (m.id, m.infohash, m.pointer);
    }

    function pointerAddress(string memory _pointer)
        public
        view
        override
        returns (address)
    {
        bytes memory pointer = bytes(_pointer);
        require(_available[pointer], "Merchant Error: pointer not found");
        return _pointerAddress[pointer];
    }
}
