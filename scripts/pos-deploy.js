// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const POS = await hre.ethers.getContractFactory("POS");
  const pos = await POS.deploy("0xb89844126ab8250a239d003e0117b13b62bfdd38");

  await pos.deployed();

  console.log("POS deployed to:", pos.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
