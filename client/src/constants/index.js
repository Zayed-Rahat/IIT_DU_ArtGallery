import { createCampaign, dashboard, logout, payment, profile, withdraw } from '../assets';

export const navlinks = [
  {
    name: 'dashboard',
    imgUrl: dashboard,
    link: '/',
  },
  {
    name: 'createCommunity',
    imgUrl: createCampaign,
    link: '/create-community',
  },
 
  // {
  //   name: 'logout',
  //   imgUrl: logout,
  //   link: '/',
  //   disabled: true,
  // },

   {
    name: 'addArt',
    imgUrl: createCampaign,
    link: '/add-art',
  },

  {
    name: 'profile',
    imgUrl: profile,
    link: '/profile',
  }
];
