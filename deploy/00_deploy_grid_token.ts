import { getUnnamedAccounts, ethers, upgrades, deployments, network } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import fs from 'fs'; // to save the contract address locally

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
  const chainId: number | undefined = network.config.chainId
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const randomAccounts = await getUnnamedAccounts();
	
  // deploy grid contract  
	const Grid = await ethers.getContractFactory('Grid');
	const gridInstance = await upgrades.deployProxy(
    Grid, [ 
      randomAccounts[0], 
      randomAccounts[1] 
    ]
  );
	await gridInstance.deployed();
	log(`grid deployed to: ${gridInstance.address}`);

  // save contract address
  try {
    fs.writeFileSync(
      //'../generated/contract-types/gridAddress.ts', 
      'gridAddress.ts', 
      `export const gridProxyContractAddress=${gridInstance.address}`
    );
  } catch (err) {
    console.error(err);
  }  

};
export default func;
func.tags = ['Grid'];

/*
Tenderly verification
let verification = await tenderly.verify({
  name: contractName,
  address: contractAddress,
  network: targetNetwork,
});
*/
