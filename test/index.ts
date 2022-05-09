import { expect } from "chai";
import { ethers, upgrades} from "hardhat";

describe("Grid", function () {

  it("Should deploy Grid tokens with 25M minted on deployment", async function () {

    const signers = await ethers.getSigners();
    // const treasuryAddress = signers[1].address

    // const gridFactory = await ethers.getContractFactory("Grid");
    // const grid = await gridFactory.deploy(treasuryAddress);
    // const grid = await gridFactory.deploy();
    // await grid.deployed();
	const grid = await ethers.getContractFactory('Grid');
    const gridProxy = await upgrades.deployProxy(grid, {
      initializer: "initialize",
    });

    // check if initial supply is accurate initial supply
    const initialSupply = await gridProxy.totalSupply();
    // console.log('Should mint (25M*10**18) 2.5e+25 Grid tokens ==>', Number(totalSupply));
    expect(Number(initialSupply)).to.equal(25000000 * 10 ** 18);

  });
});
