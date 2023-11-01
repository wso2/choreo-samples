import { get, post } from "./http";
import { AxiosResponse } from "axios";
import { CardDetails, Reward, RewardConfirmation, RewardSelection } from "./types";

// const qrGeneratorUrl = window.config.qrGeneratorApiUrl;

export const getCardDetails = async (userId: string) => {
  const url = `card-details/${userId}`;
  const response = await get(url);
  return response as AxiosResponse<CardDetails>;
};

export const getRewards = async () => {
  const url = `rewards`;
  const response = await get(url);
  return response as AxiosResponse<Reward[]>;
};

export const getRewardDetails = async (rewardId: string) => {
  const url = `rewards/${rewardId}`;
  const response = await get(url);
  return response as AxiosResponse<Reward>;
};

export const getQRCode = async (userId: string, rewardId: string) => {
  const headers = {
    'Accept': 'image/png',
  }
  const params = {
    userId: userId,
    rewardId: rewardId,
  }
  const url = 'qr-code';
  const response = await get(url, params, false, headers, 'blob');
  return response as AxiosResponse<any>;
}

export const getRewardConfirmations = async (userId: string) => {
  const params = {
    userId: userId
  }
  const url = 'reward-confirmations';
  const response = await get(url, params, false);
  console.log('initial reward confirmations');
  console.log(response);
  return response as AxiosResponse<RewardConfirmation[]>;
}


export const selectReward = async ( userId: string, selectedRewardDealId: string, acceptedTnC: boolean) => {
  const selection: RewardSelection = {
    userId,
    selectedRewardDealId,
    acceptedTnC
  };

  const url = 'select-reward'; 
  const response = await post(url, undefined, selection); 
  console.log('Reward selection response:', response);
  return response;
};