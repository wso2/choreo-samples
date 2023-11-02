import React from 'react';
import { Routes, Route } from 'react-router-dom';
import { HelmetProvider } from 'react-helmet-async';
import { ThemeProvider, StyledEngineProvider } from '@mui/material/styles';
import questTheme from 'src/QuestUiKitLightTheme';
import Q2Portal from 'src/components/Q2Portal/Q2Portal';
import Q5QrCode from 'src/components/Q5QrCode/Q5QrCode';
import Q3Rewards from 'src/components/Q3Rewards/Q3Rewards';
import Q4RewardPage from 'src/components/Q4RewardPage/Q4RewardPage';
import Q6RewardConfirmations from './components/Q6RewardConfirmations/Q6RewardConfirmations';

function App() {
  return (
    <HelmetProvider>
      <StyledEngineProvider injectFirst>
        <ThemeProvider theme={questTheme}>
          <Routes>
            <Route path="/" element={<Q2Portal />} />
            <Route path="/accounts" element={<Q2Portal />} />
            <Route path="/qr-code/:rewardId" element={<Q5QrCode />} />
            <Route path="/rewards" element={<Q3Rewards />} />
            <Route path="/reward-details/:rewardId" element={<Q4RewardPage />} />
            <Route path="/confirmed-rewards" element={<Q6RewardConfirmations />} />
          </Routes>
        </ThemeProvider>
      </StyledEngineProvider>
    </HelmetProvider>
  );
}

export default App;
