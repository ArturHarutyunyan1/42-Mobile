import { View, Text } from "react-native";

type pageProps = {
    cityName?: string
}

export default function Weekly({cityName}: pageProps)
{
    return (
        <View style={{justifyContent: "center", alignItems: "center"}}>
            <Text style={{fontSize: 50}}>{cityName || ""}</Text>
            <Text style={{fontSize: 50}}>Weekly</Text>
        </View>
    );
}