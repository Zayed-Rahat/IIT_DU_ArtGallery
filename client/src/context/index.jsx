import React, { useContext, createContext } from 'react';

import { useAddress, useContract, useMetamask, useContractWrite, useContractRead } from '@thirdweb-dev/react';
import { ethers } from 'ethers';
import Web3 from 'web3';
 import {abi} from './ArtBlock.json'

// Initialize Web3

import { EditionMetadataWithOwnerOutputSchema } from '@thirdweb-dev/sdk';

const StateContext = createContext();
const web3 = new Web3(window.ethereum);
// const contractAddress = "0x4Ba077DF5056F1fB97253d48f67ec512AEB1ede0";

export const StateContextProvider = ({ children }) => {
const { contract } = useContract('0x4Ba077DF5056F1fB97253d48f67ec512AEB1ede0');
  const { mutateAsync: CreateCommunity} = useContractWrite(contract, 'createCommunity');
  // const {  data : GetCommunities } = useContractRead(contract, 'getCommunities');

  const address = useAddress();
  const connect = useMetamask();

  const createCommunity = async (form) => {
    try {
      const data = await CreateCommunity({
				args: [
					form.title, // title
					form.description, // description
				],
			});

      console.log("contract call success", data)
    } catch (error) {
      console.log("contract call failure", error)
    }
  }

//   const getCommunities = async (a) => {
//     try {
//       // Call the getCommunities function
//       // const communities = await GetCommunities({});
//       console.log(GetCommunities);
    
//       // Parse the communities
//       const parsedCommunities =communities.map((campaign, i) => ({
//         owner : campaign.owner,
//         description: campaign.description,
        
//       }));

//   console.log(parsedCommunities);
//   return communities;
//  } catch (error) {
//   console.log("Error getting communities:", error);
//  }
// }

 

  // const getUserCampaigns = async () => {
  //   const allCampaigns = await getCampaigns();

  //   const filteredCampaigns = allCampaigns.filter((campaign) => campaign.owner === address);

  //   return filteredCampaigns;
  // }

  // const donate = async (pId, amount) => {
  //   const data = await contract.call('donateToCampaign', [pId], { value: ethers.utils.parseEther(amount)});

  //   return data;
  // }

  // const getDonations = async (pId) => {
  //   const donations = await contract.call('getDonators', [pId]);
  //   const numberOfDonations = donations[0].length;

  //   const parsedDonations = [];

  //   for(let i = 0; i < numberOfDonations; i++) {
  //     parsedDonations.push({
  //       donator: donations[0][i],
  //       donation: ethers.utils.formatEther(donations[1][i].toString())
  //     })
  //   }

  //   return parsedDonations;
  // }


  return (
    <StateContext.Provider
      value={{ 
        address,
        contract,
        connect,
        createCommunity: createCommunity,
        // getCommunities: getCommunities,
      }}
    >
      {children}
    </StateContext.Provider>
  )
}

export const useStateContext = () => useContext(StateContext);