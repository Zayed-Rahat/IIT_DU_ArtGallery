import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";

import { useStateContext } from "../context";
import { CustomButton } from ".";
import { logo, menu, search, thirdweb } from "../assets";
import { navlinks } from "../constants";

const Navbar = () => {
  const navigate = useNavigate();
  const [isActive, setIsActive] = useState("dashboard");
  const { connect, address } = useStateContext();

  return (
    <div className="flex md:flex-row flex-col-reverse justify-between mb-[35px] gap-6">
    <div className="flex flex-row justify-end gap-4">
      <div className="w-[40px] h-[40px] rounded-[10px] bg-[#2c2f32] flex justify-center items-center cursor-pointer">
      <img
          src={logo}
          alt="user"
          className="w-[60%] h-[60%] object-contain"
        />
       </div>
    </div>
  
    <div className="flex justify-between items-center">

      <ul className="flex">
        {navlinks.map((link) => (
          <li
            key={link.name}
            className={`flex p-4 ${isActive === link.name && "bg-[#3a3a43]"}`}
            onClick={() => {
              setIsActive(link.name);
              navigate(link.link);
            }}
          >
            <img
              src={link.imgUrl}
              alt={link.name}
              className={`w-[24px] h-[24px] object-contain ${
                isActive === link.name ? "grayscale-0" : "grayscale"
              }`}
            />
            <p
              className={`ml-[20px] font-epilogue font-semibold text-[14px] ${
                isActive === link.name ? "text-[#1dc071]" : "text-[#808191]"
              }`}
            >
              {link.name}
            </p>
          </li>
        ))}
      </ul>
  
      <div className="mx-4">
        <CustomButton
          btnType="button"
          title={address ? "Create Community" : "Connect"}
          styles={address ? "bg-[#1dc071]" : "bg-[#8c6dfd]"}
          handleClick={() => {
            if (address) navigate("create-community");
            else connect();
          }}
        />
      </div>
    </div>
  </div>  
  );
};

export default Navbar;
