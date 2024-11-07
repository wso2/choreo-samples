const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(
  process.env.CHOREO_DATABASE_CONNECTION_DB_NAME,
  process.env.CHOREO_DATABASE_CONNECTION_DB_USER,
  process.env.CHOREO_DATABASE_CONNECTION_DB_PASSWORD,
  {
    host: process.env.CHOREO_DATABASE_CONNECTION_DB_HOST,
    dialect: 'mysql',
    port: process.env.CHOREO_DATABASE_CONNECTION_DB_PORT,
  }
);

sequelize.authenticate().then(() => {
  console.log('Connection has been established successfully.');
}).catch(err => {
  console.error('Unable to connect to the database:', err);
});

module.exports = sequelize;
