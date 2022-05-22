import { getUnnamedAccounts, ethers, upgrades, deployments, network } from 'hardhat';
import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import fs from 'fs'; // to save the contract address locally

// const exportContract = async (fileName: string, address: string) => {
//   try {
//     fs.writeFileSync(
//       fileName, 
//       `export const gridProxyContractAddress=${address}`
//     );
//   } catch (err) {
//     console.log(err);
//   }  
// }

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
	const { getNamedAccounts, deployments } = hre;
  const chainId: number | undefined = network.config.chainId
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const randomAccounts = await getUnnamedAccounts();
	
  // deploy grid contract  
  const deployed = await deploy('Grid', {
		from: deployer,
		log: true,
	});

  // call initialize with...
  // args: [randomAccounts[0], randomAccounts[1]]

  // const deployed = await deploy('Grid', {
	// 	from: deployer,
	// 	args: [randomAccounts[0], randomAccounts[1]],
	// 	log: true,
	// });

  // const Grid = await ethers.getContractFactory('Grid');
	// const gridInstance = await upgrades.deployProxy(
  //   Grid, [ 
  //     randomAccounts[0], 
  //     randomAccounts[1] 
  //   ]
  // );
	// await gridInstance.deployed();
	// log(`GRID deployed to: ${JSON.stringify(deployed,null,2)}`);
	log(`GRID deployed to: ${deployed.address}`)

  // save contract address
  // await exportContract('gridAddress.ts', gridInstance.address);
  // fs.writeFile("gridAddress.ts", "Hey there!", function(err) {
  //   if(err) {
  //       return console.log(err);
  //   }
  //   // console.log("The file was saved!");
  // }); 

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
