import React, { useState, useEffect } from 'react'

import { DisplayCommunities } from '../components';
import { useStateContext } from '../context'

const Profile = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [communities, setCommunities] = useState([]);

  const { address, contract, getCommunities } = useStateContext();

  const fetchCommunities = async () => {
    setIsLoading(true);
    const data = await getCommunities();
    console.log(data)
    setCommunities(data);
    setIsLoading(false);
  }

  useEffect(() => {
    if(contract) fetchCommunities();
  }, [address, contract]);

  return (
    <DisplayCommunities 
      title="All Communities"
      isLoading={isLoading}
      communities={communities}
    />
  )
}

export default Profile