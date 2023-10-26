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