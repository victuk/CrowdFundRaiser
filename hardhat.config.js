require("dotenv").config();

require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: process.env.sepoliaUrl,
      accounts: [process.env.privateKey],
    }
  },
  etherscan: {
    apiKey: process.env.apiKey
  }
};
