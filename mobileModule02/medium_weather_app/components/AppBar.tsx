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
                        color="royalblue"
                    >
                    </FontAwesomeIcon>
                </TouchableOpacity>
            </View>
            <View style={styles.searchResult}>
            {searchResults.length > 0 && searchResults.map(result => (
              <TouchableOpacity>
                <View key={result.longitude} style={styles.resultItem}>
                    <Text style={{fontSize: 23}}>{result.name}</Text>
                    <Text style={{fontSize: 18, color: "#ccc"}}>{result.country}</Text>
                </View>
              </TouchableOpacity>
            ))}
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container:
    {
        width: "90%",
        flexDirection: "row",
        alignItems: "center",
        paddingHorizontal: 10,
        paddingVertical: 5,
        margin: "auto",
        marginTop: 20,
        backgroundColor: "#fff",
        borderRadius: 15

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
    },
    searchResult:
    {
      width: "90%",
      height: "auto",
      backgroundColor: "#fff",
      padding: 10,
      zIndex: 999,
      margin: "auto",
      marginTop: 10,
      borderRadius: 20
    },
    resultItem:
    {
      width: "100%",
      margin: "auto",
      // height: 30,s
    }
})