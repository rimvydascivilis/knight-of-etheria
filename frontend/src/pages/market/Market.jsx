import React, {useEffect, useState} from 'react';
import {ethers, parseEther} from 'ethers';
import constants from '../../utils/constants';
import {useOutletContext} from 'react-router-dom';
import './Market.css';

function Market() {
  const itemMaterials = ['none', 'wood', 'iron', 'steel', 'diamond'];
  const itemTypes = ['helmet', 'armor', 'boots', 'weapon'];
  const [provider, playerAddress] = useOutletContext();

  const [inventoryItems, setInventoryItems] = useState(Array(20).fill({
    'type': 0,
    'material': 0,
  }));
  const [shopItems, setShopItems] = useState([]);
  const [playerGold, setPlayerGold] = useState(0);

  const getItemPrice = ([type, material], _shopItems) => {
    for (let i = 0; i < _shopItems.length; i++) {
      if (_shopItems[i]['type'] == type && _shopItems[i]['material'] == material) {
        return _shopItems[i]['price'];
      }
    }
  };

  const fetchPlayerGold = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const gold = (await playerContract.gold()).toString();
    setPlayerGold(gold);
  };

  const fetchInventoryItems = async (_shopItems) => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const items = Array(20);
    for (let i = 0; i < 20; i++) {
      const item = (await playerContract.inventory(i)).toString().split(',');
      items[i] = {
        'type': item[0],
        'material': item[1],
        'price': getItemPrice([item[0], item[1]], _shopItems),
      };
    }
    setInventoryItems(items);
  };

  const fetchShopItems = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const itemsAddr = await playerContract.getItemsAddress();
    const itemsContract = new ethers.Contract(itemsAddr, constants.itemsContract.abi, signer);
    const items = [];
    for (let i = 0; i < itemTypes.length; i++) {
      for (let j = 1; j < itemMaterials.length; j++) {
        const item = (await itemsContract.getItem([i, j])).toString().split(',');
        items.push({
          'type': item[0],
          'material': item[1],
          'attack': item[2],
          'defense': item[3],
          'price': item[4],
        });
      }
    }
    setShopItems(items);
  };

  const sellItem = async (_idx) => {
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    await gameContract.sellItem(_idx);
  };

  const buyItem = async ([type, material]) => {
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    await gameContract.buyItem(type, material);
  };

  const buyGold = async () => {
    const signer = await provider.getSigner();
    const gameContract = new ethers.Contract(constants.gameContract.address, constants.gameContract.abi, signer);
    await gameContract.buyGold({value: parseEther('0.01')});
  };

  useEffect(() => {
    fetchPlayerGold();
    fetchShopItems();
  }, []);

  useEffect(() => {
    fetchInventoryItems(shopItems);
  }, [shopItems]);

  const getItemImgSrc = (item) => {
    return `items/${itemTypes[item['type']]}/${item['material']}.png`;
  };

  return (
    <div className="d-flex flex-column">
      <div className="d-flex justify-content-between">
        <h2>Gold: {playerGold}</h2>
        <button onClick={() => buyGold()}>Buy 100g for 0.01Eth</button>
      </div>

      <div className="d-flex justify-content-center column-gap-5">
        <div className="align-self-start">
          <h2 className="d-flex justify-content-center">Buy Items</h2>
          <div className="shop-items">
            {shopItems.map((item, idx) => (
              <div key={idx} className="shop-item d-flex flex-column align-items-center">
                <img src={getItemImgSrc(item)} alt="shop item"></img>
                <button onClick={() => buyItem([item['type'], item['material']])}>Buy for {item['price']}g</button>
              </div>
            ))}
          </div>
        </div>

        {inventoryItems[0]['type'] == 0 ? null : (
          <div className="align-self-start">
            <h2 className="d-flex justify-content-center">Sell Items</h2>
            <div className="sell-items">
              {inventoryItems.map((item, idx) => {
                if (item['type'] == 0) return;
                return (
                  <div key={idx} className="sell-item d-flex flex-column align-items-center">
                    <img src={getItemImgSrc(item)} alt="shop item"></img>
                    <button onClick={() => sellItem(idx)}>Sell for {item['price']}g</button>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default Market;
