import React, {useEffect, useState} from 'react';
import {ethers} from 'ethers';
import constants from '../../utils/constants';
import {useOutletContext} from 'react-router-dom';

function Market() {
  const itemMaterials = ['none', 'wood', 'iron', 'steel', 'diamond'];
  const itemTypes = ['helmet', 'armor', 'boots', 'weapon'];
  const [provider, playerAddress] = useOutletContext();

  const [inventoryItems, setInventoryItems] = useState(Array(20).fill({
    'type': 0,
    'material': 0,
  }));
  const [shopItems, setShopItems] = useState([]);

  const fetchInventoryItems = async () => {
    const signer = await provider.getSigner();
    const playerContract = new ethers.Contract(playerAddress, constants.playerContract.abi, signer);
    const items = Array(20);
    for (let i = 0; i < 20; i++) {
      const item = (await playerContract.inventory(i)).toString().split(',');
      items[i] = {
        'type': item[0],
        'material': item[1],
      };
    }
    setInventoryItems(items);
  };

  const getItemImgSrc = (item) => {
    return `items/${itemTypes[item['type']]}/${item['material']}.png`;
  }

  useEffect(() => {
    fetchInventoryItems();
  }, []);

  return (
    <div className="d-flex column-gap-5">

      <div className="align-self-end">
        <h2>Buy Items</h2>
        <div className="inventory-items">
          {inventoryItems.map((item, idx) => (
            <div key={idx} className="border border-dark rounded">
              <div className="inventory-item" onClick={() => equipItem(idx)}>
                {item.material != 0 ? (
                  <img src={getItemImgSrc(item)} alt="inventory item"></img>
                ) : null}
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="align-self-end">
        <h2>Sell Items</h2>
        <div className="inventory-items">
          {inventoryItems.map((item, idx) => (
            <div key={idx} className="border border-dark rounded">
              <div className="inventory-item" onClick={() => equipItem(idx)}>
                {item.material != 0 ? (
                  <img src={getItemImgSrc(item)} alt="inventory item"></img>
                ) : null}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default Market;