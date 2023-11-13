function generateWeatherTable(WeatherRecordList weatherRecords) returns string {
    // Define the table header
    string[] columns = ["   Date and Time   ", "Description", "Temperature", "Humidity", "Wind", "Cloud"];
    string separator = " | ";
    string wtable = separator;

    // Add the table header
    foreach var column in columns {
        wtable = wtable + column + separator;
    }
    wtable = wtable + "\n";
    
    // Add the table body
    foreach var wrecord in weatherRecords.list {
        wtable = wtable + separator + wrecord.dt_txt + separator + wrecord.weather[0].description
        + separator + (wrecord.main.temp - 273.0).round(2).toString() + separator + (wrecord.main.humidity).toString()
        + "%" + separator + (wrecord.wind.speed).toString() + " m/s, " + (wrecord.wind.deg).toString()
        + "°" + separator + (wrecord.clouds.all).toString() + "%" + separator + "\n";
    }

    // Add the table footer
    wtable = wtable + "\n";
    return wtable;
}
