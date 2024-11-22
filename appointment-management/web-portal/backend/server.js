require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const authenticate = require('./src/authenticate');

const app = express();
const port = process.env.PORT || 8080;
const appointmentServiceUrl = process.env.CHOREO_APPOINTMENT_CONNECTION_SERVICEURL;

app.use(bodyParser.json());

async function getAccessToken() {
    const tokenUrl = process.env.CHOREO_APPOINTMENT_CONNECTION_TOKENURL;
    const clientId = process.env.CHOREO_APPOINTMENT_CONNECTION_CONSUMERKEY;
    const clientSecret = process.env.CHOREO_APPOINTMENT_CONNECTION_CONSUMERSECRET;

    try {
        const accessToken = await authenticate(tokenUrl, clientId, clientSecret);
        return accessToken;
    } catch (error) {
        console.error('Error obtaining access token:', error);
        throw error; // Rethrow the error to handle it in the calling context
    }
}

// Endpoint to get appointments, filtering by email
app.get('/appointments', async (req, res) => {
    try {
        const email = req.query.email;
        if (!email) {
            return res.status(400).send('Email query parameter is required');
        }

        const accessToken = await getAccessToken(); // Use the new function

        const response = await axios.get(`${appointmentServiceUrl}/appointments?email=${email}`, {
            headers: {
                'Authorization': `Bearer ${accessToken}`,
            },
        });

        res.status(response.status).send(response.data);
    } catch (error) {
        console.error('Error fetching appointments:', error);
        res.status(error.response ? error.response.status : 500).send(error.message);
    }
});

app.post('/create-appointment', async (req, res) => {
    try {
        // Retrieve authentication details from environment variables
        const accessToken = await getAccessToken(); // Use the new function here too

        if (!appointmentServiceUrl) {
            throw new Error('Appointment service URL is not defined in the environment variables');
        }

        const response = await axios.post(`${appointmentServiceUrl}/appointments`, req.body, {
            headers: {
                'Authorization': `Bearer ${accessToken}`,
            },
        });

        // Respond to the client with the Appointment service's response
        res.status(response.status).send(response.data);
    } catch (error) {
        console.error('Error forwarding appointment creation request:', error);
        res.status(error.response ? error.response.status : 500).send(error.message);
    }
});

app.get('/appointment-types', async (req, res) => {
    try {
        const accessToken = await getAccessToken(); // Obtain the access token
        if (!appointmentServiceUrl) {
            throw new Error('Appointment service URL is not defined in the environment variables');
        }

        const response = await axios.get(`${appointmentServiceUrl}/appointment-types`, {
            headers: {
                'Authorization': `Bearer ${accessToken}`,
            },
        });

        // Respond to the client with the appointment types from the appointment service
        res.status(response.status).send(response.data);
    } catch (error) {
        console.error('Error fetching appointment types:', error);
        res.status(error.response ? error.response.status : 500).send(error.message);
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
