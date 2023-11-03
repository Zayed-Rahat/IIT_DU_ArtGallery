import React, { useState, useEffect  } from 'react'
import { useNavigate } from 'react-router-dom';
import { ethers } from 'ethers';
import Web3 from 'web3';
import { useStateContext } from '../context';
import { money } from '../assets';
import { CustomButton, FormField, Loader } from '../components';

const CreateCommunity = () => {
  const navigate = useNavigate();
  const [isLoading, setIsLoading] = useState(false);
  const { createCampaign } = useStateContext();
  const [form, setForm] = useState({
    title: '',
    description: '',
    tokenSymbol: '',
    tokenAmount: '',
    creatorAddress: '',
  });


  useEffect(() => {
    // Connect to the user's Metamask wallet
    const connectToMetamask = async () => {
      if (window.ethereum) {
        try {
          // Request access to the user's accounts
          await window.ethereum.request({ method: 'eth_requestAccounts' });
          const web3 = new Web3(window.ethereum);

          // Retrieve the token symbol and token amount from the user's wallet
          const tokenContract = new web3.eth.Contract(ERC20_ABI, tokenContractAddress);
          const tokenSymbol = await tokenContract.methods.symbol().call();
          const tokenAmount = await tokenContract.methods.balanceOf(web3.eth.defaultAccount).call();

          // Retrieve the creator address from the user's wallet
          const creatorAddress = web3.eth.defaultAccount;

          // Update the form state with the retrieved values
          setForm((prevForm) => ({
            ...prevForm,
            tokenSymbol,
            tokenAmount,
            creatorAddress,
          }));
        } catch (error) {
          console.error('Error connecting to Metamask:', error);
        }
      } else {
        console.error('Metamask not detected');
      }
    };

    connectToMetamask();
  }, []);

  const handleFormFieldChange = (fieldName, event) => {
    setForm((prevForm) => ({
      ...prevForm,
      [fieldName]: event.target.value,
    }));
  };


  const handleSubmit = async (e) => {
    e.preventDefault();
  }

  return (
    <div className="bg-[#1c1c24] flex justify-center items-center flex-col rounded-[10px] sm:p-10 p-4">
      {isLoading && <Loader />}
      <div className="flex justify-center items-center p-[16px] sm:min-w-[380px] bg-[#3a3a43] rounded-[10px]">
        <h1 className="font-epilogue font-bold sm:text-[25px] text-[18px] leading-[38px] text-white">Create a Community</h1>
      </div>

      <form onSubmit={handleSubmit} className="w-full mt-[65px] flex flex-col gap-[30px]">
        <div className="flex flex-wrap gap-[40px]">
          <FormField 
            labelName="Title *"
            placeholder="Write a title"
            inputType="text"
            value={form.title}
            handleChange={(e) => handleFormFieldChange('title', e)}
          />
        </div>

        <FormField 
            labelName="Description *"
            placeholder="Write your description"
            isTextArea
            value={form.description}
            handleChange={(e) => handleFormFieldChange('description', e)}
          />

      <p>Token Symbol: {form.tokenSymbol}</p>
      <p>Token Amount: {form.tokenAmount}</p>
      <p>Creator Address: {form.creatorAddress}</p>

        <div className="flex flex-wrap gap-[40px]">
         
        </div>
          <div className="flex justify-center items-center mt-[40px]">
            <CustomButton 
              btnType="submit"
              title="Submit new community"
              styles="bg-[#1dc071]"
            />
          </div>
      </form>
    </div>
  )
}

export default CreateCommunity