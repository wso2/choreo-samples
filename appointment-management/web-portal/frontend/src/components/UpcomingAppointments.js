import React, { useEffect, useState } from 'react';
import { getUpcomingAppointments } from '../services/appointmentService';
import { services } from '../serviceData';
import { List, ListItem, ListItemText, Typography, Paper, Avatar, ListItemAvatar, Divider } from '@mui/material';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import { format } from 'date-fns';

// Convert service values to labels for display
const getServiceLabel = (serviceValue) => {
    const service = services.find(s => s.value === serviceValue);
    return service ? service.label : serviceValue; // Fallback to the value if not found
};

const UpcomingAppointments = ({ email, triggerRefresh }) => {
    const [appointments, setAppointments] = useState([]);

    useEffect(() => {
        const fetchAppointments = async () => {
            if (!email) return;

            try {
                const upcomingAppointments = await getUpcomingAppointments(email);
                setAppointments(upcomingAppointments);
            } catch (error) {
                console.error('Failed to fetch appointments:', error);
            }
        };

        fetchAppointments();
    }, [email, triggerRefresh]);

    if (appointments.length === 0) {
        return (
            <Typography variant="subtitle1" style={{ marginTop: 20, textAlign: 'center' }}>
                No upcoming appointments. Take a moment to book one!
            </Typography>
        );
    }

    return (
        <Paper style={{ margin: 16, maxWidth: 600, width: '100%' }}>
            <List>
                {appointments.map((appointment, index) => (
                    <React.Fragment key={index}>
                        <ListItem>
                            <ListItemAvatar>
                                <Avatar>
                                    <CalendarTodayIcon />
                                </Avatar>
                            </ListItemAvatar>
                            <ListItemText
                                primary={getServiceLabel(appointment.service)}
                                secondary={`On ${format(new Date(appointment.appointmentDate), 'MMMM d, yyyy, h:mm a')} for ${appointment.name}`}
                            />
                        </ListItem>
                        {index < appointments.length - 1 && <Divider />}
                    </React.Fragment>
                ))}
            </List>
        </Paper>
    );
};

export default UpcomingAppointments;
