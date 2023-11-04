import React from 'react';
import { useNavigate } from 'react-router-dom';
import { v4 as uuidv4 } from "uuid";
import FundCard from './FundCard';
import { loader } from '../assets';
import { useContractRead } from '@thirdweb-dev/react';


const DisplayCommunities = ({ title, isLoading, contract }) => {
  const navigate = useNavigate();

  const {  data : communities } = useContractRead(contract, "getCommunities");


  console.log(communities)

  
  // const handleNavigate = (campaign) => {
  //   navigate(`/campaign-details/${campaign.title}`, { state: campaign })
  // }
  
  return (
    <div>
      <h1 className="font-epilogue font-semibold text-[18px] text-white text-left">{title} ({communities.length})</h1>

      <div className="flex flex-wrap mt-[20px] gap-[26px]">
        {isLoading && (
          <img src={loader} alt="loader" className="w-[100px] h-[100px] object-contain" />
        )}

        {!isLoading && communities.length === 0 && (
          <p className="font-epilogue font-semibold text-[14px] leading-[30px] text-[#818183]">
            You have not created any communities yet
          </p>
        )}

        {!isLoading && communities.length > 0 && communities.map((community) => <FundCard 
          key={uuidv4()}
          {...community}
          handleClick={() => handleNavigate(community)}
        />)}
      </div>
    </div>
  )
}

export default DisplayCommunities