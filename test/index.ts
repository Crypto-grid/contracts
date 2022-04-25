import { expect } from "chai";
import { ethers } from "hardhat";

describe("Grid", function () {
  it("Should deploy Grid with correct premint amount", async function () {
    const Grid = await ethers.getContractFactory("Grid");
    const signers = await ethers.getSigners();
    const grid = await Grid.deploy(20000000, signers[1].address, signers[2].address, signers[3].address);
    await grid.deployed();

    expect(await grid.totalSupply()).to.equal(20000000);
  });
});