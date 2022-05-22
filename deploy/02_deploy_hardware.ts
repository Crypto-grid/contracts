import { getUnnamedAccounts, ethers, upgrades, network } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import Networks from "../assets/deploy.json";
import { deployedContractAddresses } from '../assets/fallbackDeployedContractAddresses'; 


// import upgradesContractAddress from './upgradesProxyContractAddress'

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();

  var aggregator;
  if (deployments.getNetworkName() === "Mumbai") {
      aggregator = Networks.Mumbai.address.ETHAggregatorV3
  }

  const chainId: number | undefined = network.config.chainId

  let ethUsdPriceFeedAddress: string | undefined
  if (chainId === 31337) {
    const EthUsdAggregator = await deployments.get("MockV3Aggregator")
    ethUsdPriceFeedAddress = EthUsdAggregator.address
  } else {
    ethUsdPriceFeedAddress = undefined
  }
  log(`EthUsdAggregator contract deployed to: ${ethUsdPriceFeedAddress}`);

  // constructor(address _aggregatorAddress, address _upgradeTokenAddress) {
	const deployed = await deploy("HardwareFactory", {
		// Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
		from: deployer,
		// args: [aggregator, upgradesContractAddress],
		args: [ethUsdPriceFeedAddress, deployedContractAddresses.local.upgrades],
		log: true,
	});

  log(`HARDWAREFACTORY contract deployed to: ${deployed.address}`);
	
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
