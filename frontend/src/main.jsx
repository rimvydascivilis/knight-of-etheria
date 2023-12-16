import React from 'react';
import ReactDOM from 'react-dom/client';
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import Battle from './pages/battle/Battle';
import Wardrobe from './pages/wardrobe/Wardrobe';
import Root from './routes/Root';
import './index.css';

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    children: [
      {
        path: "battle",
        element: <Battle />,
      },
      {
        path: "market",
        element: <Wardrobe />,
      },
      {
        path: "wardrobe",
        element: <Wardrobe />,
        index: true,
      }
    ]
  },
], {basename: "/knight-of-etheria/"});

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
      <RouterProvider router={router} />
    </React.StrictMode>,
);
