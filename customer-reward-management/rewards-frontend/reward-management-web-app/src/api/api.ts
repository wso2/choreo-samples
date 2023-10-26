import { get } from "./http";
import { AxiosResponse } from "axios";
import { CardDetails, Reward } from "./types";

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
