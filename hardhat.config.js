require('@nomicfoundation/hardhat-toolbox');
require('@nomiclabs/hardhat-solhint');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.20',
  paths: {
    artifacts: './frontend/src/artifacts',
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 1,
    },
  },
};
