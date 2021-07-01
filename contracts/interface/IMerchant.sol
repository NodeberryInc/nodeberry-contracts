// SPDX-License-Identifier: ISC
pragma solidity ^0.8.4;

interface IMerchant {
    function register(string memory _pointer, string memory _hash)
        external
        returns (bool);

    function merchantInfo(address _query)
        external
        view
        returns (
            address,
            bytes memory,
            bytes memory
        );

    function pointerAddress(string memory _pointer)
        external
        view
        returns (address);
}
