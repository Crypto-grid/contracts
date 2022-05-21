import { getUnnamedAccounts, ethers, upgrades } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { isBoxedPrimitive } from 'util/types';

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
	const { deploy } = deployments;
	const { deployer } = await getNamedAccounts();
	const randomAccounts = await getUnnamedAccounts();
	await deploy('MineFactory', {
		from: deployer,
		args: [],
		log: true,
	})
	// above should output: address _gridETH, address _gridBTC, address _gridXMR,
	// args to be sent in for Upgrades deployment


	await deploy('Upgrades', {
		// Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
		from: deployer,
		// args: [20000000, randomAccounts[0], randomAccounts[1], randomAccounts[2]],
		args: [_gridETH, _gridBTC, _gridXMR],
		log: true,
	});

	const upgrades = await ethers.getContractFactory('Upgrades');
	const upgradesProxy = await upgrades.deployProxy(grid, {
		initializer: 'initialize',
	});

	await upgradesProxy.deployed();
	console.log('upgradesProxy deployed to: ', upgradesProxy.address);

	/*
    // Getting a previously deployed contract
    const YourContract = await ethers.getContract("YourContract", deployer);
    await YourContract.setPurpose("Hello");

    //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */
};
export default func;
func.tags = ["UpgradeToken"];

/*
Tenderly verification
let verification = await tenderly.verify({
  name: contractName,
  address: contractAddress,
  network: targetNetwork,
});
*/
