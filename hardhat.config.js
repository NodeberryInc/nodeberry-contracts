/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-ethers");
 require("@nomiclabs/hardhat-truffle5");
 require("@nomiclabs/hardhat-etherscan");
 require('dotenv').config();

 module.exports = {
   solidity: "0.8.4",
   networks: {
     kovan: {
       url: `https://kovan.infura.io/v3/${process.env.INFURA_KEY}`,
       accounts: [`0x${process.env.PRIVATE_KEY}`]
     }
   },
   etherscan: {
     apiKey: process.env.ETHSCAN_KEY
   },
 };
 