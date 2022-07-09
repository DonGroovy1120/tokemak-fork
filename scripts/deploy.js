// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

const uniswapFactory = "0x1f98431c8ad98523631ae4a59f267346ea31f984";
const uniswapRouter = "0x68b3465833fb72a70ecdf485e0e4c7bd8665fc45";
const tokeAddress = "0x67d822994C698cC8E57541d89B97763bbd069F73"
const mangerAddress ="0x32c438dc05C2e84a3236b5E63CBdC720b0ED2787"
const addressRegistryAddress="0x55D1B1EBa3aDE428565CB76E8C2154f46ea831C1"
const signerAddress = "0x912d97c66457420c4F23561f42c592EBa3c9cf48"
async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // // We get the contract to deploy
  // const Toke = await hre.ethers.getContractFactory("Toke");
  // const toke = await Toke.deploy();
  // await toke.deployed();
  // console.log("Toke deployed to:", toke.address);

  // const Manager = await hre.ethers.getContractFactory("Manager");
  // const manager = await Manager.deploy();
  // await manager.deployed();
  // console.log("manager deployed to:", manager.address);

  // const AddressRegistry = await hre.ethers.getContractFactory("AddressRegistry");
  // const addressRegistry = await AddressRegistry.deploy();
  // await addressRegistry.deployed();
  // console.log("addressRegistry deployed to:", addressRegistry.address);

  // const BalanceTracker = await hre.ethers.getContractFactory("BalanceTracker");
  // const balanceTracker = await BalanceTracker.deploy();
  // await balanceTracker.deployed();
  // console.log("balanceTracker deployed to:", balanceTracker.address);

  // const Staking = await hre.ethers.getContractFactory("Staking");
  // const staking = await Staking.deploy();
  // await staking.deployed();
  // console.log("staking deployed to:", staking.address);

  // const EthPool = await hre.ethers.getContractFactory("EthPool");
  // const ethPool = await EthPool.deploy();
  // await ethPool.deployed();
  // console.log("ethPool deployed to:", ethPool.address);

  // const SushiswapControllerV2 = await hre.ethers.getContractFactory("SushiswapControllerV2");
  // const sushiswapControllerV2 = await SushiswapControllerV2.deploy();
  // await sushiswapControllerV2.deployed();
  // console.log("sushiswapControllerV2 deployed to:", sushiswapControllerV2.address);

  // const UniswapController = await hre.ethers.getContractFactory("UniswapController");
  // const uniswapController = await UniswapController.deploy(uniswapRouter, uniswapFactory, mangerAddress, addressRegistryAddress);
  // await uniswapController.deployed();
  // console.log("uniswapController deployed to:", uniswapController.address);

  // const EventProxy = await hre.ethers.getContractFactory("EventProxy");
  // const eventProxy = await EventProxy.deploy();
  // await eventProxy.deployed();
  // console.log("eventProxy deployed to:", eventProxy.address);

  const Treasury = await hre.ethers.getContractFactory("GnosisSafe");
  const treasury = await Treasury.deploy();
  await treasury.deployed();
  console.log("Treasury deployed to:", treasury.address);

  // const Rewards = await hre.ethers.getContractFactory("Rewards");
  // const rewards = await Rewards.deploy(tokeAddress, signerAddress);
  // await rewards.deployed();
  // console.log("rewards deployed to:", rewards.address);
  
  // const RewardsHash = await hre.ethers.getContractFactory("RewardHash");
  // const rewardHash = await RewardsHash.deploy();
  // await rewardHash.deployed();
  // console.log("rewardHash deployed to:", rewardHash.address);

  // const OnChainVoteL1 = await hre.ethers.getContractFactory("OnChainVoteL1");
  // const onChainVoteL1 = await OnChainVoteL1.deploy();
  // await onChainVoteL1.deployed();
  // console.log("onChainVoteL1 deployed to:", onChainVoteL1.address);

  // const VoteTracker = await hre.ethers.getContractFactory("VoteTracker");
  // const voteTracker = await VoteTracker.deploy();
  // await voteTracker.deployed();
  // console.log("voteTracker deployed to:", voteTracker.address);
    
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
