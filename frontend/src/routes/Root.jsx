import React, {useEffect, useState} from 'react';
import ConnectMetaMask from '../components/ConnectMetaMask.jsx';
import CreatePlayer from '../components/CreateCharacter.jsx';
import NavBar from '../components/NavBar.jsx';
import {Outlet} from 'react-router-dom';
import {ethers} from 'ethers';
import constants from '../utils/constants.js';

function Root() {
  const [playerAddress, setPlayerAddress] = useState(constants.addressZero);
  const [provider, setProvider] = useState(null);

  const fetchPlayerAddress = async () => {
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    const player = (await gameContract.getCharacterAddress()).toString();
    setPlayerAddress(player);
  };

  useEffect(() => {
    const initializeProvider = async () => {
      if (window.ethereum) {
        await window.ethereum.request({method: 'eth_requestAccounts'});
        const provider = new ethers.BrowserProvider(window.ethereum);
        setProvider(provider);
      }
    };
    initializeProvider();
  }, []);

  useEffect(() => {
    if (provider) {
      fetchPlayerAddress();
    }
  }, [provider]);

  const renderContent = (content) => {
    return (
      <>
        <NavBar />
        <div className='container d-flex justify-content-center align-items-center'>
          {content}
        </div>
      </>
    );
  };

  if (!provider) {
    return renderContent(<ConnectMetaMask />);
  } else if (!playerAddress || playerAddress === constants.addressZero) {
    return renderContent(<CreatePlayer provider={provider} setPlayerAddress={setPlayerAddress} />);
  } else {
    return renderContent(<Outlet context={[provider, playerAddress]} />);
  }
}

export default Root;
