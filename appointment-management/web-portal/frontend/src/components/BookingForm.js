// components/BookingForm.js

import React, { useState, useEffect } from 'react';
import { TextField, MenuItem, Button, CircularProgress } from '@mui/material';
import { LocalizationProvider, DateTimePicker } from '@mui/x-date-pickers';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { add, startOfDay } from 'date-fns';
import { bookAppointment, fetchAppointmentTypes } from '../services/appointmentService';

const BookingForm = ({ userDetails, handleOpenSnackbar, onBookingSuccess }) => {
    const defaultAppointmentDate = add(startOfDay(new Date()), { days: 1, hours: 10 });

    const [name, setName] = useState(userDetails.name || userDetails.username);
    const [phoneNumber, setPhoneNumber] = useState('');
    const [service, setService] = useState('');
    const [appointmentDate, setAppointmentDate] = useState(defaultAppointmentDate);
    const [services, setServices] = useState([]); // State to store fetched services
    const [loadingServices, setLoadingServices] = useState(false);
    const [errors, setErrors] = useState({
        name: '',
        phoneNumber: '',
        service: '',
        appointmentDate: '',
    });
    const [isBooking, setIsBooking] = useState(false);

    // Effect to update state when userDetails changes
    useEffect(() => {
        setName(userDetails.name || userDetails.username);
        const loadServices = async () => {
            try {
                setLoadingServices(true);  // Start loading before the fetch
                const fetchedServices = await fetchAppointmentTypes();
                setServices(fetchedServices);
                setLoadingServices(false); // Stop loading after fetch
            } catch (error) {
                console.error('Failed to load appointment types:', error);
                handleOpenSnackbar('Failed to load services.');
                setLoadingServices(false); // Ensure loading is stopped even if an error occurs
            }
        };
        loadServices();
    }, [userDetails, handleOpenSnackbar]);

    const validateForm = () => {
        let tempErrors = { name: '', service: '', appointmentDate: '', phoneNumber: '' };
        let isValid = true;

        if (!name) {
            tempErrors.name = 'Name is required.';
            isValid = false;
        }

        if (!service) {
            tempErrors.service = 'Please select a service.';
            isValid = false;
        }

        if (!appointmentDate || new Date(appointmentDate) < new Date()) {
            tempErrors.appointmentDate = 'Please select a future date and time.';
            isValid = false;
        }

        // Basic validation for phone number
        const phoneRegex = /^[0-9]{10}$/; // Adjust the regex according to your needs
        if (!phoneNumber) {
            tempErrors.phoneNumber = 'Phone number is required.';
            isValid = false;
        } else if (!phoneRegex.test(phoneNumber)) {
            tempErrors.phoneNumber = 'Phone number is 10 digits.';
            isValid = false;
        }

        setErrors(tempErrors);
        return isValid;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validateForm()) return;

        setIsBooking(true); // Start loading

        const appointmentDetails = {
            name,
            phoneNumber,
            service,
            appointmentDate,
            email: userDetails.email, // Include the email in your appointment details
        };

        try {
            await bookAppointment(appointmentDetails);
            handleOpenSnackbar('Appointment booked successfully!');

            onBookingSuccess(); // Add this line. You need to pass this prop from App.js

            // Reset form fields
            setService('');
            setAppointmentDate(defaultAppointmentDate);
            setPhoneNumber('');
        } catch (error) {
            console.error('Booking failed:', error);
            handleOpenSnackbar('Failed to book the appointment. Please try again.');
        } finally {
            setIsBooking(false); // Stop loading regardless of the outcome
        }
    };

    return (
        <form onSubmit={handleSubmit} style={{ width: '100%' }}>
            <TextField
                label="Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                error={!!errors.name}
                helperText={errors.name}
                fullWidth
                margin="normal"
                variant="outlined"
            />
            <TextField
                label="Phone Number"
                value={phoneNumber}
                onChange={(e) => setPhoneNumber(e.target.value)}
                error={!!errors.phoneNumber}
                helperText={errors.phoneNumber}
                fullWidth
                margin="normal"
                variant="outlined"
                type="tel" // Suggests to browsers that this input should be treated as a telephone number
            />
            <TextField
                select
                label="Service"
                value={service}
                onChange={(e) => setService(e.target.value)}
                error={!!errors.service}
                helperText={errors.service}
                fullWidth
                margin="normal"
                variant="outlined"
                disabled={loadingServices}  // Disable the field while loading
            >
                {loadingServices ? (
                    <MenuItem disabled>Loading...</MenuItem>
                ) : (
                    services.map((option) => (
                        <MenuItem key={option.value} value={option.value}>
                            {option.label}
                        </MenuItem>
                    ))
                )}
            </TextField>
            <LocalizationProvider dateAdapter={AdapterDateFns}>
                <DateTimePicker
                    label="Appointment Date"
                    value={appointmentDate}
                    onChange={(newValue) => setAppointmentDate(newValue)}
                    slotProps={{
                        textField: {
                            variant: 'outlined',
                            fullWidth: true,
                            margin: 'normal',
                            error: !!errors.appointmentDate,
                            helperText: errors.appointmentDate,
                        }
                    }}
                />
            </LocalizationProvider>
            <Button type="submit" variant="contained" color="primary" fullWidth style={{ marginTop: 20, position: 'relative' }} disabled={isBooking}>
                Book Appointment
                {isBooking && (
                    <CircularProgress
                        size={24}
                        style={{
                            position: 'absolute',
                            top: '50%',
                            left: '50%',
                            marginTop: -12,
                            marginLeft: -12,
                        }}
                    />
                )}
            </Button>
        </form>
    );
};

export default BookingForm;
