import { Outlet, ScrollRestoration } from 'react-router-dom';
import './App.css';

function App() {
  return (
    <>
      <ScrollRestoration />
      <Outlet />
    </>
  );
}

export default App;
