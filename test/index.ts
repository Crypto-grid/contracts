import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { BigNumber, Contract } from 'ethers';
import { ethers, upgrades } from 'hardhat';

// 25M (initial token supply)
// 25000000000000000000000000
// 25,000,000,000,000,000,000,000,000

// 2.5M (10% treasury)
// 2500000000000000000000000
// 2,500,000,000,000,000,000,000,000

describe('Grid', async function () {

  let tokenContractAddress: string;
  let signers: SignerWithAddress[];
  let gridProxy: Contract;
  let initialSupply: BigInteger;
  let initialTreasury: BigInteger;

  this.beforeAll(async function () {
    signers = await ethers.getSigners();
		const admin2 = signers[1].address;
		const admin3 = signers[2].address;
		const grid = await ethers.getContractFactory('Grid');
		gridProxy = await upgrades.deployProxy(grid, [admin2, admin3]);
		tokenContractAddress = gridProxy.address;
    initialSupply = await gridProxy.totalSupply();
    initialTreasury =  await gridProxy.getTreasuryTokens()
    // console.log(initialTreasury);
    // const initTreasuryAmount: BigNumber = BigNumber.from("2500000000000000000000000");
    // console.log('Initial GRTOKENS:',Number(initialSupply));
    // console.log('Initial TREASURY:',Number(initTreasuryAmount));
  })

  it('Should deploy Grid tokens with 25M minted on deployment', async function () {
		expect(Number(initialSupply)).to.equal(25000000000000000000000000);
		// console.log('Should mint (25M*10**18) 2.5e+25 Grid tokens ==>', Number(totalSupply));
	});

	// it('Should not allow define admins by not-admins', async function () {
  //   const someRandomUser = signers[3].address;
  //   // const wrongCall = await gridProxy.setGridAdministrators()
	// 	expect(1).to.equal(1);
	// });

	it('Should allocate 10% of tokens to treasury', async function () {
		expect(Number(initialTreasury)).to.equal(2500000000000000000000000);
	});
});

