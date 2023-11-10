type WeatherRecord record {
    string dt_txt;
    MainData main;
    Weather[] weather;
    Clouds clouds;
    Wind wind;
};

type MainData record {
    float temp;
    int humidity;
};

type Weather record {
    string main;
    string description;
};

type Clouds record {|
    int all;
|};

type Wind record {|
    float speed;
    int deg;
    float gust;
|};

type WeatherRecordList record {
    WeatherRecord[] list;
};
