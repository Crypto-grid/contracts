import { getUnnamedAccounts, ethers, upgrades, deployments, network } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
// import { deployedContractAddresses } from '../generated/contract-addresses/DeployedContactAddresses';
// import {
//   networkConfig,
//   // developmentChains,
//   // VERIFICATION_BLOCK_CONFIRMATIONS,
// } from "../helper-hardhat-config"
// import { isBoxedPrimitive } from 'util/types';

//TODO: how to get price feeds for btc, eth etc via chainlink?? - arguments for deploy Upgrades

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
  const chainId: number | undefined = network.config.chainId
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const randomAccounts = await getUnnamedAccounts();
	
  const mineDeployed = await deploy('MineFactory', {
		from: deployer,
		args: [],
		log: true,
	})
	
	// above should output: address _gridETH, address _gridBTC, address _gridXMR,
	// args to be sent in for Upgrades deployment
	// const factory = await ethers.getContractFactory('MineFactory');
	// const mine = await factory.deploy();
	// await mine.deployed();

	// get the mine token contract address
	const mineContractAddress = mineDeployed.address;
	log(`MINE contract deployed to: ${mineDeployed.address}`);

  // let ethUsdPriceFeedAddress: string | undefined
  // if (chainId === 31337) {
  //   const EthUsdAggregator = await deployments.get("MockV3Aggregator")
  //   ethUsdPriceFeedAddress = EthUsdAggregator.address
  // } else {
  //   ethUsdPriceFeedAddress = undefined
  // }
  // log(`EthUsdAggregator contract deployed to: ${ethUsdPriceFeedAddress}`);

  // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  const upgradeDeployed = await deploy('Upgrades', {
		from: deployer,
		// args: [btcPF, ethPF, mineContractAddress], // xmrPF - price feed not available on test net 
		// args: [ethUsdPriceFeedAddress, ethUsdPriceFeedAddress, mineContractAddress], // xmrPF - price feed not available on test net 
		log: true,
	});

  // call initialize with...
  // args: [ethUsdPriceFeedAddress, ethUsdPriceFeedAddress, mineContractAddress], // xmrPF - price feed not available on test net 

	log(`UPGRADES contract deployed to: ${upgradeDeployed.address}`);
  
	// const upgrades = await ethers.getContractFactory('Upgrades');
	// const upgradesProxy = await upgrades.deployProxy(grid, {
	// 	initializer: 'initialize',
	// });

	// await upgradesProxy.deployed();
	// console.log('upgradesProxy deployed to: ', upgradesProxy.address);

	// fs.writeFileSync('./upgradesProxyContractAddress.ts', `export const upgradesContractAddress='${upgradesProxy.address}'`);

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
