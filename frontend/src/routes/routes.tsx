import { createBrowserRouter } from 'react-router-dom';
import App from '../App';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      {
        path: '/',
        lazy: async () => {
          const { LandingPage } = await import('../pages/home/LandingPage');
          return { Component: LandingPage };
        },
      },
    ],
  },
]);
