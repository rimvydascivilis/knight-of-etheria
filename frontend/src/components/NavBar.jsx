import React from 'react';
import {Link} from 'react-router-dom';

export default function NavBar() {
  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light">
      <div className="container-fluid">
        <Link className='navbar-brand' to={`/`}>Knight Of Etheria</Link>
        <div className="navbar-collapse" id="navbarNav">
          <ul className="navbar-nav">
            <li className="nav-item">
              <Link className='nav-link' to={`/battle`}>Battle</Link>
            </li>
            <li className="nav-item">
              <Link className='nav-link' to={`/market`}>Market</Link>
            </li>
            <li className="nav-item">
              <Link className='nav-link' to={`/wardrobe`}>Wardrobe</Link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
}
