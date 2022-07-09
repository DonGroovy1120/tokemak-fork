/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-web3");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;

task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.6.11",
        settings: {
          optimizer: {
            enabled: true,
          },
        },
      },
      {
        version: "0.5.14",
        settings: {
          optimizer: {
            enabled: true,
          },
        },
      },
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
          },
        },
      },
    ],
  },
  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    brise: {
      url: `https://node.thesphynx.co/mainnet`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  // etherscan: {
  //   apiKey: {
  //     brise: process.env.ETHSCAN_API_KEY
  //   },
  //   customChains: [
  //     {
  //       network: "brise",
  //       chainId: 32520,
  //       urls: {
  //         apiURL: "https://brisescan.com/api",
  //         browserURL: "https://brisescan.com"
  //       }
  //     }
  //   ]
  // },
  etherscan: {
    apiKey: process.env.ETHSCAN_API_KEY,
  },
};
