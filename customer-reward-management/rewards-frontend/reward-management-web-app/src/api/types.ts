export interface CardDetails{
    userId: string;
    cardNumber: string;
    rewardPoints: number
    currentBalance: number
    dueAmount: number
    lastStatementBalance: number
    availableCredit: number
}

export interface Reward{
    id: string;
    name: string;
    logoUrl: string;
    value: number;
    totalPoints: number;
    description?: string;
}

export interface RewardConfirmation{
    userId: string;
    rewardId: string;
    qrCode: string;
}


export interface RewardSelection {
    userId: string;
    selectedRewardDealId: string;
    acceptedTnC: boolean;
}