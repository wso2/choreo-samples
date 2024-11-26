// LoginPage.js
import React from 'react';
import { Button, Typography, Box, Paper, Container } from '@mui/material';
import backgroundImage from './login-background.webp'; // Ensure this path is correct

const LoginPage = () => {
    return (
        <Box
            sx={{
                minHeight: '100vh',
                backgroundImage: `url(${backgroundImage})`,
                backgroundRepeat: 'no-repeat',
                backgroundSize: 'cover', // Ensures the background covers the area without spaces
                backgroundPosition: 'center', // Centers the background image
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
            }}
        >
            <Container maxWidth="xs">
                <Paper
                    elevation={3}
                    sx={{
                        padding: 4,
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        backgroundColor: 'rgba(255, 255, 255, 0.8)', // Slightly transparent white
                    }}
                >
                    <Typography variant="h4" component="h1" gutterBottom sx={{ textAlign: 'center' }}>
                        Welcome to CareConnect
                    </Typography>
                    <Typography variant="subtitle1" gutterBottom sx={{ mb: 2, textAlign: 'center' }}>
                        Your gateway to health and wellness
                    </Typography>
                    <Button
                        variant="contained"
                        color="primary"
                        sx={{ mt: 2 }}
                        onClick={() => window.location.href = "/auth/login"}
                    >
                        Login
                    </Button>
                </Paper>
            </Container>
        </Box>
    );
};

export default LoginPage;
