import { View, Text } from "react-native";

type pageProps = {
    cityName?: string
}

export default function Today({cityName}: pageProps)
{
    return (
        <View style={{justifyContent: "center", alignItems: "center"}}>
            <Text style={{fontSize: 50}}>{cityName || ""}</Text>
            <Text style={{fontSize: 50}}>Today</Text>
        </View>
    );
}