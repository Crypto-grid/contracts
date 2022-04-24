# Crypto-Grid

This will be a hyper realistic Play to Earn (P2E) crypto currency mining simulator.  The game will leverage its own token $GRID and users will own NFTs relating to land and equipment.
Miners will have to weigh up where to build their mining operation based on real world issues such as locally available energy sources and prices, government restrictions on crypto mining and geopolitical events such as war.

## $Grid Tokenomics

The $GRID token is the engine underneath CryptoGrid's hood. It will facilitate player-based micro-transactions such as "selling" one's GPUs/CPUs/ASICs/lands on the marketplace. But, it will also be a digital real estate tool, useful for the buying and renting of land. In this case, the tokens will be burned in the interest of sustainability.

**Total Supply**: 750,000,000 (Hard Cap)

**Only Possible Addition**: Ultra rare (1x10^-6%) chance of claiming rewards related to mining and selling silicon lottery equipment to the game.

**Pre-Mint**
Of the 750 million $GRID, only 25 million (3.33%) will be minted upon initial deployment.

Of that 25 million...

**25% (6.25 Million)** Towards the developers' multi-signature wallet to fund the development of the game.

**30% (7.5 Million)** Will fund the initial liquidity pool on a DEX (ex. Sushiswap).

**10% (2.5 Million)** Towards Marketing (Over 5 Years).

**10% (2.5 Million)** To Hire other staff, contractors and freelancers.

**25% (6.5 Million)** Player incentives to stake their tokens into our DEX farm to promote price stability.

**Additional Info**
Name: CryptoGrid
Symbol: GRID
Decimals: 18

The rest of the tokens are proposed to incentivize players (e.g. mining rewards).
4% of any NFT sale will return to the game treasury.

## $UPGRADES TOKENOMICS

$UPGRADES is a token where mined tokens like gridXMR, gridETH, gridBTC can be traded in the game to the token. There will not be any supply cap for this token.

$UPGRADES can be used for upgrades in the game for example minting new NFT equipment (CPU,GPU and ASIC) where rarity of the item will be determined through chainlink VRFs.

$UPGRADES will also be used to rebirth and progress in the game which will reset all their items and all gridX tokens.

**Additional Info**
Name: Upgrades
Symbol: UPG
Decimals: 18
Max Supply: Infinite


## Proposed Stack

## Proposed Game Renderer

At the moment three js (WebGL) is proposed, however open for discussion. Ian has previous experience building 3d scenes in three js.

## Proposed Data Storage

**Data that will not change**: IPFS
**Data that will/could change**: Backend API syncing up game JSON data

- Option 1: IPFS to point to new data (e.g. <https://ipfs.io/>)
- Option 2: Modify JSON through REST call API ([Chainlink API Calls](https://docs.chain.link/docs/advanced-tutorial/))

Metadata relating to NFTs is proposed to be stored on chain.

## Uses of Chainlink

- [Crypto prices](https://docs.chain.link/docs/consuming-data-feeds/) relating to rewards in dollar value
- Perhaps use [random numbers](https://docs.chain.link/docs/get-a-random-number/) for when user would receive mining rewards between all competing nodes

Future uses:

1. Weather data for energy yields from natural sources
2. Geopolitical restrictions on mining operations
3. Energy prices in different part of the world

## Hardhat

### Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

### Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

### Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).
