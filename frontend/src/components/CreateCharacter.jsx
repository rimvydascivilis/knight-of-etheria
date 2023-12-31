import React from 'react';
import PropTypes from 'prop-types';
import {ethers, parseEther} from 'ethers';
import constants from '../utils/constants.js';

function CreateCharacter({provider, setPlayerAddress}) {
  const createCharacter = async () => {
    const fetchPlayerAddress = async () => {
      const signer = await provider.getSigner();
      const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
      let player = await gameContract.getCharacterAddress();
      player = player.toString();
      setPlayerAddress(player);
    };
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    const transaction = await gameContract.createCharacter({value: parseEther('0.1')});
    await transaction.wait().then(() => {
      fetchPlayerAddress();
    });
  };

  return (
    <div className='container d-flex flex-column justify-content-center align-items-center'>
      <h1>Create Character</h1>
      <button onClick={createCharacter}>Create Character 0.1 Eth</button>
    </div>
  );
}

CreateCharacter.propTypes = {
  provider: PropTypes.object,
  setPlayerAddress: PropTypes.func,
};

export default CreateCharacter;
