# Variable Finance Smart Contracts

This repository contains the smart contracts of the variable finance on-chain POS eco-system. It forms the basis of creating merchant accounts, processing payments & real-time settlements.

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

---

## Getting Started

### Prerequisites

The repository is built using hardhat. So it is recommended to install hardhat globally through npm or yarn using the following commands. Also the development of these smart contracts are done in npm version 7.16.0 & NodeJs version 16.1.0

`sudo npm i -g hardhat`

### Installation

Step by step instructions on setting up the project and running it

1. Clone the repository
   `git clone https://github.com/Variable-Finance/variable-v1-core`
2. Install Dependencies
   `npm install`
3. Compiling Smart Contracts (Auto compiles all .sol file inside contracts directory)
   `npx hardhat compile`
4. Deploying Smart Contracts
   `npx hardhat run scripts/<contract-name>_deploy.js --network <network-name>`

   > Network name can be kovan for kovan testnet and testnet for BSC testnet. For adding other networks, please configure them in hardhat.config.js file in the root directory.
   > Name of the smart contracts can be found inside the scripts folders in the root directory.

5. Verification of Smart Contracts
   `npx hardhat verify <deployed-contract-address> --network <network-name> --constructor-args arguments/<contract-name>.argument.js`

   > Network name can be kovan for kovan testnet and testnet for BSC testnet. For adding other networks, please configure them in hardhat.config.js file in the root directory.
   > Name of the smart contracts to be verified can be found inside the arguments folders in the root directory.

### Project structure

1. All contract codes, interfaces and utilites imported in the smart contracts can be found at [/contracts](./contracts)
2. All chainlink related contracts are found at [/contracts/chainlink](./contracts/chainlink)
3. All contract interfaces are found at [/contracts/interface](./contracts/interface).
4. The helper contracts can be found at [/contract/utils](./contracts/utils)
5. Security contracts can be found at [/contract/security](./contracts/security)
6. Deployment scripts for deploying the smart contracts can be found at [/scripts](./scripts)

   > These are the codes that have to be created while deploying the smart contracts. Make sure the arguments
   > are appropriate before deployment.

7. Verification arguments are added and stored as .js files inside [/arguments](./arguments)

   > Change these to the deployed contract arguments to successfully verify your contract in explorers. These arguments are the ones that we used in the constructor of the smart contract during their deployment. For verification purpose, we store it here.

All configuration is done in hardhat.config.js & linting configurations are made in .solhint.json & .prettierrc
