// import { getUnnamedAccounts, ethers, upgrades, network } from 'hardhat';
// import { DeployFunction } from 'hardhat-deploy/types';
// import { HardhatRuntimeEnvironment } from 'hardhat/types';
// import Networks from '../assets/deploy.json';
// import { deployedContractAddresses } from '../assets/fallbackDeployedContractAddresses';

// const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
// 	const { getNamedAccounts, deployments } = hre;
// 	const { deploy, log } = deployments;
// 	const { deployer } = await getNamedAccounts();
//     const factory = await deployments.execute('HardwareFactory', {from: deployer}, "createHardware", []);

// 	const account = await deploy('Account', {
// 		// Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
// 		from: deployer,
// 		// args: [aggregator, upgradesContractAddress],
// 		args: [(await deployments.get("Upgrades")).address, 0],
// 		log: true,
// 	});

// 	log(`Account contract deployed to: ${account.address}`);
// };
// export default func;
// func.tags = ['Hardware'];

// /*
// Tenderly verification
// let verification = await tenderly.verify({
//   name: contractName,
//   address: contractAddress,
//   network: targetNetwork,
// });
// */
