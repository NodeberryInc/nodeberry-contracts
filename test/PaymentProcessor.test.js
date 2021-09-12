const { expect, assert } = require("chai");

describe("Payment Processor Test Suite", function() {
  let tokenA;
  let tokenB;
  let oracleA;
  let paymentContract;
  let deployer;
  let initialSupply = ethers.utils.parseEther("1000000");
  let price = ethers.utils.parseUnits("1", 8); // $10 represented in 8 decimals;

  before(async function() {
    const PaymentContract = await ethers.getContractFactory("TestProcessor");
    const tokenContract = await ethers.getContractFactory("TestToken");
    const oracleContract = await ethers.getContractFactory("Oracle");

    tokenA = await tokenContract.deploy(initialSupply);
    tokenB = await tokenContract.deploy(initialSupply);
    paymentContract = await PaymentContract.deploy();
    oracleA = await oracleContract.deploy(price);
    [deployer] = await ethers.getSigners();
  });

  describe("Validating Deployed Smart Contract", async function() {
    it("Should check Token Contract Params", async function() {
      expect(await tokenA.decimals()).to.equal(18);
      expect(await tokenA.totalSupply()).to.equal(initialSupply);
    });
  
    it("Should check Oracle Contract Params", async function() {
      const data = await oracleA.latestRoundData();
      expect(data[1]).to.equal(price);
    });
    
    it("Should check Payment Processor Contract Params", async function() {
      const owner = await paymentContract.owner();
      expect(owner).to.equal(deployer.address);
    });
  });

  describe("Unit Tests - Configurations & Upgradations", async function() {
    it("should throw error when try to replace oracle without setting", async function() {
      let err = null;
      try {
        await paymentContract.replaceOracle(oracleA.address, "TestToken");
      } catch (error) {
        err = error;
      }
      assert.ok(err instanceof Error);
    });

    it("should set oracle Address", async function() {
      await paymentContract.setOracle(deployer.address, "TestToken");
      expect(await paymentContract.fetchOracle("TestToken")).to.equal(deployer.address);
    });

    it("should throw error when try to set oracle again", async function() {
      let err = null;
      try {
        await paymentContract.setOracle(oracleA.address, "TestToken");
      } catch (error) {
        err = error;
      }
      assert.ok(err instanceof Error);
    }); 

    it("should update oracle Address", async function() {
      await paymentContract.replaceOracle(oracleA.address, "TestToken");
      expect(await paymentContract.fetchOracle("TestToken")).to.equal(oracleA.address);
    });

    it("should throw error when try to replace contract address without setting", async function() {
      let err = null;
      try {
        await paymentContract.replaceContract(tokenA.address, "TestToken");
      } catch (error) {
        err = error;
      }
      assert.ok(err instanceof Error);
    });

    it("should set token contract Address", async function() {
      await paymentContract.setContract(deployer.address, "TestToken");
      await paymentContract.setContract(tokenB.address, "TestStableCoin");
      expect(await paymentContract.fetchContract("TestToken")).to.equal(deployer.address);
    });

    it("should throw error when try to set contract address again", async function() {
      let err = null;
      try {
        await paymentContract.setContract(tokenA.address, "TestToken");
      } catch (error) {
        err = error;
      }
      assert.ok(err instanceof Error);
    }); 

    it("should update token contract Address", async function() {
      await paymentContract.replaceContract(tokenA.address, "TestToken");
      expect(await paymentContract.fetchContract("TestToken")).to.equal(tokenA.address);
    });

    it("should set a token as stablecoin", async function() {
      await paymentContract.markAsStablecoin("TestStableCoin");
  });
  });

  describe("Unit Tests - Fetching", async function() {
    it("should return user allowance", async function() {
      await tokenA.approve(paymentContract.address, 10);
      let result = await paymentContract.fetchApproval("TestToken", deployer.address);
      expect(result).to.equal(10);
    });

    it("should return oracle price", async function() {
      let result = await paymentContract.fetchOraclePrice("TestToken");
      expect(result).to.equal(price);
    });
  });

  describe("Unit Tests - Stablecoin Payments", async function() {
    it("should validate the token decimal calculation", async function() {
      let usd = 100000000;
      let result = await paymentContract.sAmount("TestStableCoin", usd);
      expect(result).to.equal(ethers.utils.parseEther("1"));
    });

    it("should process payments in TestToken as Stablecoin", async function() {
      let usd = 100000000;
      await tokenB.approve(paymentContract.address, initialSupply);
      await paymentContract.mockSale("TestStableCoin", usd);
    });
  });

  describe("Unit Tests - Token Payments", async function() {
    it("should process payments in TestToken as Stablecoin", async function() {
      let usd = 100000000;
      await tokenA.approve(paymentContract.address, initialSupply);
      await paymentContract.mockSale("TestToken", usd);
    });
  });
});
