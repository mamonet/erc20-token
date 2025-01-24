const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20 Token", function () {
  let contract;
  let owner, signer1, signer2;

  beforeEach(async () => {
    [owner, signer1, signer2] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory(
      "contracts/ERC20Token.sol:ERC20Token",
      owner
    );
    contract = await Contract.deploy();
    await contract.deployed();
  });

  it("Checking the initial tokens", async function () {
    expect(await contract.getTokens()).to.equal(ethers.utils.parseEther("8000000"));
  });

  it("Checking the blance of owener, initially it is supposed to be equal to the initial tokens", async function () {
    expect(await contract.getBalance(owner.address)).to.equal(ethers.utils.parseEther("8000000"));
  });

  it("Checking the result of transfer from the available balance", async function () {
    await expect(contract.send(signer1.address, ethers.utils.parseEther("1")))
      .to.emit(contract, "Transfer")
      .withArgs(owner.address, signer1.address, ethers.utils.parseEther("1"));
    expect(await contract.getBalance(signer1.address)).to.equal(ethers.utils.parseEther("1"));

    // Failed to transfer because signer1 does not have enough balance
    await contract.connect(signer1).send(signer2.address, ethers.utils.parseEther("2"));
    expect(await contract.getBalance(signer1.address)).to.equal(ethers.utils.parseEther("1"));
    expect(await contract.getBalance(signer2.address)).to.equal(ethers.utils.parseEther("0"));

    await contract.connect(signer1).send(signer2.address, ethers.utils.parseEther("0.1"));
    expect(await contract.getBalance(signer1.address)).to.equal(ethers.utils.parseEther("0.9"));
    expect(await contract.getBalance(signer2.address)).to.equal(ethers.utils.parseEther("0.1"));
  });

  it("Checking the result of transfer from the available balance using a third party limit", async function () {
    await contract.approve(signer1.address, ethers.utils.parseEther("1"));
    expect(await contract.limit(owner.address, signer1.address)).to.equal(
      ethers.utils.parseEther("1")
    );

    await contract
      .connect(signer1)
      .transfer(owner.address, signer2.address, ethers.utils.parseEther("1"));
    expect(await contract.getBalance(signer2.address)).to.equal(ethers.utils.parseEther("1"));
  });
});
