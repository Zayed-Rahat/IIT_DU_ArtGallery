import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { ethers } from "ethers";

import { useStateContext } from "../context";
import { money } from "../assets";
import { CustomButton, FormField, Loader } from "../components";
import { checkIfImage } from "../utils";

const AddArt = () => {
  const navigate = useNavigate();
  const [isLoading, setIsLoading] = useState(false);
  const { publishProduct } = useStateContext();
  const [form, setForm] = useState({
    title: "",
    description: "",
    image: "",
    stakeAmount: "",
    isExclusive: false,
  });

  const handleFormFieldChange = (fieldName, e) => {
    setForm({ ...form, [fieldName]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    checkIfImage(form.image, async (exists) => {
      if (exists) {
        setIsLoading(true);
        await publishProduct({
          ...form,
          target: ethers.utils.parseUnits(form.target, 18),
        });
        setIsLoading(false);
        navigate("/art-gallery");
      } else {
        alert("Provide valid image URL");
        setForm({ ...form, image: "" });
      }
    });
  };

  return (
    <div className="bg-[#1c1c24] flex justify-center items-center flex-col rounded-[10px] sm:p-10 p-4">
      {isLoading && <Loader />}
      <div className="flex justify-center items-center p-[16px] sm:min-w-[380px] bg-[#3a3a43] rounded-[10px]">
        <h1 className="font-epilogue font-bold sm:text-[25px] text-[18px] leading-[38px] text-white">
          A an Art
        </h1>
      </div>

      <form
        onSubmit={handleSubmit}
        className="w-full mt-[65px] flex flex-col gap-[30px]"
      >
        <div className="flex flex-wrap gap-[40px]">
          <FormField
            labelName="Title *"
            placeholder="title"
            inputType="text"
            value={form.title}
            handleChange={(e) => handleFormFieldChange("title", e)}
          />
          <FormField
            labelName="Description *"
            placeholder="Write a  description"
            inputType="text"
            value={form.description}
            handleChange={(e) => handleFormFieldChange("description", e)}
          />
        </div>

        <FormField
          labelName="Stake Amount *"
          placeholder="amount"
          isTextArea
          value={form.stakeAmount}
          handleChange={(e) => handleFormFieldChange("stakeAmount", e)}
        />

        <FormField
          labelName="Image *"
          placeholder="Place image URL of your campaign"
          inputType="url"
          value={form.image}
          handleChange={(e) => handleFormFieldChange("image", e)}
        />

        <FormField
          labelName="Is this campaign exclusive?"
          type="checkbox"
          value={form.isExclusive}
          handleChange={(e) => handleFormFieldChange("isExclusive", e)}
        />

        <div className="flex justify-center items-center mt-[40px]">
          <CustomButton
            btnType="submit"
            title="Submit new campaign"
            styles="bg-[#1dc071]"
          />
        </div>
      </form>
    </div>
  );
};

export default AddArt;
