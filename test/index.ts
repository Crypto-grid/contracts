import { expect } from "chai";
import { ethers } from "hardhat";

describe("Grid", function () {

  it("Should deploy Grid tokens with 25M minted on deployment", async function () {
    
    const signers = await ethers.getSigners();
    // const treasuryAddress = signers[1].address

    const gridFactory = await ethers.getContractFactory("Grid");    
    // const grid = await gridFactory.deploy(treasuryAddress);
    const grid = await gridFactory.deploy();
    await grid.deployed();

    // check if initial supply is accurate initial supply
    const initialSupply = await grid.totalSupply();
    // console.log('Should mint (25M*10**18) 2.5e+25 Grid tokens ==>', Number(totalSupply));
    expect(initialSupply).to.be.not.undefined;
    expect(initialSupply).to.be.not.null;
    expect(initialSupply).to.be.not.NaN;
    expect(Number(initialSupply)).to.equal(25000000000000000000000000);

  });

});
