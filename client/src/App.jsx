import React from 'react';
import { Route, Routes } from 'react-router-dom';

import { Navbar } from './components';
import {AddArt, CreateCommunity, Home, Profile } from './pages';

const App = () => {
  return (
    <div className="relative sm:-8 p-4 bg-[#13131a] min-h-screen flex flex-row">
      <div className="sm:flex hidden mr-10 relative">
      </div>

      <div className="flex-1 max-sm:w-full max-w-[1280px] mx-auto sm:pr-5">
        <Navbar />

        <Routes>
          {/* <Route path="/" element={<Profile />} /> */}
          <Route path="/" element={<Home />} />

          <Route path="/create-community" element={<CreateCommunity />} />
          <Route path="/add-art" element={<AddArt />} />

        </Routes>
      </div>
    </div>
  )
}

export default App