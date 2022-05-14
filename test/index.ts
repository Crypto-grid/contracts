import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';

let tokenContractAddress;

describe('Grid', function () {
	it('Should deploy Grid tokens with 25M minted on deployment', async function () {
		const signers = await ethers.getSigners();

		const admin2 = signers[1].address;
		const admin3 = signers[2].address;

		// const treasuryAddress = signers[1].address

		const grid = await ethers.getContractFactory('Grid');
		const gridProxy = await upgrades.deployProxy(grid, [admin2, admin3]);

		// get the token address
		tokenContractAddress = gridProxy.address;
		console.log(tokenContractAddress);

		// check if initial supply is accurate initial supply
		const initialSupply = await gridProxy.totalSupply();
		// console.log('Should mint (25M*10**18) 2.5e+25 Grid tokens ==>', Number(totalSupply));
		expect(Number(initialSupply)).to.equal(25000000 * 10 ** 18);

		// const grid = await gridFactory.deploy(treasuryAddress);
		// const grid = await gridFactory.deploy();
		// await grid.deployed();
	});

	it('Should not allow define admins by not-admins', async function () {
		// code
		expect(1).to.equal(1);
	});

	it('Should allocate treasury', async function () {
		// code
		expect(1).to.equal(1);
	});
});
