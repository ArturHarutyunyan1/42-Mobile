import { View, Text } from "react-native";

type pageProps = {
    cityName?: string,
    lat?: number,
    log?: number,
}

export default function Today({cityName, lat, log}: pageProps)
{
    return (
        <View style={{justifyContent: "center", alignItems: "center"}}>
            <Text style={{fontSize: 50}}>{cityName || ""}</Text>
            <Text style={{fontSize: 50}}>Today</Text>
            <Text style={{ fontSize: 20 }}>Latitude: {lat}</Text>
            <Text style={{ fontSize: 20 }}>Longitude: {log}</Text>
        </View>
    );
}