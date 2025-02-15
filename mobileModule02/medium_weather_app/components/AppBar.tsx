import { Stack } from "expo-router";
import { StyleSheet, View, Text, TextInput, Keyboard, TouchableOpacity, FlatList } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { FontAwesomeIcon } from "@fortawesome/react-native-fontawesome";
import { faMagnifyingGlass, faLocationArrow } from "@fortawesome/free-solid-svg-icons";
import { useState } from "react";
import { GEOCODING_API } from "@env";

type Handler = {
  setCityName: (name: string) => void;
};

interface LocationData {
  name: string;
  country?: string;
  latitude?: number;
  longitude?: number;
}

export default function AppBar({ setCityName }: Handler) {
    const [message, sendMessage] = useState("");
    const [searchResults, setSearchResults] = useState<LocationData[]>([]);
    const [isSubmitted, setIsSubmitted] = useState(false);
  
    const handleSubmit = async () => {
      if (!message.trim()) {
        setSearchResults([]);
        return;
      }
      
      setIsSubmitted(true);
  
      try {
        const apiUrl = `${GEOCODING_API}?name=${message}`;
        console.log(apiUrl + "NIGGA");
        
        console.log("Fetching:", apiUrl);
    
        const res = await fetch(apiUrl);
        if (!res.ok) throw new Error("Failed to fetch data");
    
        const jsonData = await res.json();
    
        if (jsonData.results && jsonData.results.length > 0) {
          setSearchResults(jsonData.results);
        } else {
          setSearchResults([]);
        }
      } catch (error) {
        console.log("ERROR Occurred:", error);
        setSearchResults([]);
      }
  
      Keyboard.dismiss();
    };
    return (
        <View style={{position: "fixed", top: 40, width: "100%", height: 120}}>
            <Stack screenOptions={{ headerShown: false }}></Stack>
            <Stack.Screen
                options={{
                    headerShown: false,
                    title: ""
                }}
            />
            <View style={styles.container}>
                <FontAwesomeIcon
                    icon={faMagnifyingGlass}
                    style={styles.icon}
                    size={20}
                />
                <TextInput
                    placeholder="Search..."
                    style={styles.input}
                    onChangeText={sendMessage}
                    onSubmitEditing={handleSubmit}
                >
                </TextInput>
                <TouchableOpacity
                onPress={() => setCityName("Geolocation")}>
                    <FontAwesomeIcon
                        icon={faLocationArrow}
                        size={25}
                        style={{marginRight: 50}}
                    >
                    </FontAwesomeIcon>
                </TouchableOpacity>
            </View>
            {searchResults.length > 0 && searchResults.map(result => (
                <View key={result.longitude} style={{width: "100%", height: "auto", padding: 10, backgroundColor: "red"}}>
                    <Text>{result.name}</Text>
                </View>
            ))}
        </View>
    );
}

const styles = StyleSheet.create({
    container:
    {
        borderBottomWidth: 1,
        flexDirection: "row",
        alignItems: "center",
        paddingHorizontal: 10,
        paddingVertical: 5,
    },
    icon:
    {
        color: "#ccc",
        marginRight: 3
    },
    input:
    {
        width: "85%",
        height: 50,
        padding: 10,
        fontSize: 30
    }
})