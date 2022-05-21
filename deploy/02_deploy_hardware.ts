import { getUnnamedAccounts, ethers, upgrades } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { isBoxedPrimitive } from 'util/types';
import Networks from "./deploy.json";

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
	const { deploy } = deployments;
	const { deployer } = await getNamedAccounts();
    var aggregator;
    if (deployments.getNetworkName() === "Mumbai") {
        aggregator = Networks.Mumbai.address.ETHAggregatorV3
    }
  
	await deploy("HardwareFactory", {
		// Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
		from: deployer,
		args: [aggregator, upgrades],
		log: true,
	});

	

	/*
    // Getting a previously deployed contract
    const YourContract = await ethers.getContract("YourContract", deployer);
    await YourContract.setPurpose("Hello");

    //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */
};
export default func;
func.tags = ["Hardware"];

/*
Tenderly verification
let verification = await tenderly.verify({
  name: contractName,
  address: contractAddress,
  network: targetNetwork,
});
*/
