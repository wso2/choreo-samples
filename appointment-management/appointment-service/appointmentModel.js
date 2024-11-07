const { DataTypes } = require('sequelize');
const sequelize = require('./database');

const Appointment = sequelize.define('Appointment', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  service: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phoneNumber: {
    type: DataTypes.STRING(10),
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      isEmail: true,
    },
  },
  appointmentDate: {
    type: DataTypes.DATE,
    allowNull: false,
  },
}, {
  // Other model options go here
});

module.exports = Appointment;
