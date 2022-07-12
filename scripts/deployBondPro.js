// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

const dao = "0xD8EcB212CDAdC24Be5c1Fa32e3205B1af0f414B6"
const treasury = "0x0c54fc3Eb695598f476dAC5c80500efB5Dc4164d"
const storage = "0x7693c4629eBa623d62BEbc16619fd08a2b0647E8"
const oPSubsidy = "0x0667a846ae1191FE18804b18DCFEF87a3C6B417E"
async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');
  
//   const OlympusProFactoryStorage = await hre.ethers.getContractFactory("OlympusProFactoryStorage");
//   const olympusProFactoryStorage = await OlympusProFactoryStorage.deploy();
//   await olympusProFactoryStorage.deployed();
//   console.log("olympusProStorage deployed to:", olympusProFactoryStorage.address);
 
//   const OPSubsidyRouter = await hre.ethers.getContractFactory("OPSubsidyRouter");
//   const oPSubsidyRouter = await OPSubsidyRouter.deploy();
//   await oPSubsidyRouter.deployed();
//   console.log("oPSubsidyRouter deployed to:", oPSubsidyRouter.address);
  
  const OlympusProFactory = await hre.ethers.getContractFactory("OlympusProFactory");
  const olympusProFactory = await OlympusProFactory.deploy(treasury, storage , oPSubsidy, dao);
  await olympusProFactory.deployed();
  console.log("olympusProFactory deployed to:", olympusProFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
