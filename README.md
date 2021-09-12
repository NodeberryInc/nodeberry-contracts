# Solidity Payment Processor

A Library for Processing Stablecoin Payments & ERC20 payments in smart contract development. Built for easier payment processing inside smart contracts.

Supports 50+ ERC20 tokens & all stablecoins. Integrate to your smart contracts with ease.

[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier-solidity/prettier-plugin-solidity)
![Code-coverage: 98.44%](https://img.shields.io/badge/Code--coverage-98.44%25-green)

### Table of contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project structure](#project-structure)

### Built with

- [Hardhat](https://hardhat.org/) - Smart Contract Development Suite
- [Solhint](https://protofire.github.io/solhint/) - Linting Suite
- [Prettier](https://github.com/prettier-solidity/prettier-plugin-solidity) - Automatic Code Formatting
- [Solidity](https://docs.soliditylang.org/en/v0.8.6/) - Smart Contract Programming Language
- [Chainlink](https://chain.link/) - Price Feed (Free)

---

## Getting Started

### Prerequisites

The repository is built using hardhat. So it is recommended to install hardhat globally through npm or yarn using the following commands. Also the development of these smart contracts are done in npm version v7.21.1 & NodeJs version v16.1.0

`sudo npm i -g hardhat`

### Project structure

1. All contract codes, interfaces and utilites imported in the smart contracts can be found at [/contracts](./contracts)
2. All chainlink related contracts are found at [/contracts/chainlink](./contracts/chainlink)
3. All contract interfaces are found at [/contracts/interface](./contracts/interface).
4. An example implementation is given at [/contracts/example](./contracts/example).

All configuration is done in hardhat.config.js & linting configurations are made in .solhint.json & .prettierrc

### Directory layout

    ├── contracts
    	├── chainlink
    	├── example
    	├── interface
    	├── mock
    	├── PaymentProcessor.sol
    ├── test
    ├── .prettierrc
    ├── .eslintrc.js
    ├── .solcover.js
    ├── .solhint.json
    ├── package.json
    ├── hardhat.config.js
    └── README.md

### Testing

For running unit & integration tests:

```sh
$ npm run test
```

To run code-coverage:

```sh
$  npm run coverage
```

### Contribute

Nodeberry Contracts exists thanks to its contributors. There are many ways you can participate and help build high quality software.

### License

The Contracts are released under the MIT License.
