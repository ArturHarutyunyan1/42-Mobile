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
              {searchResults.length > 0 && (
                <FlatList
                  data={searchResults}
                  keyExtractor={(item) => `${item.longitude}-${item.latitude}`}
                  renderItem={({ item }) => (
                    <TouchableOpacity style={styles.resultItem} activeOpacity={0.7}>
                      <Text style={styles.resultText}>{item.name}</Text>
                      <Text style={styles.resultSubText}>{item.country}</Text>
                    </TouchableOpacity>
                  )}
                />
              )}
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
    searchResult: {
      width: "90%",
      height: 300,
      backgroundColor: "#fff",
      paddingVertical: 10,
      paddingHorizontal: 15,
      zIndex: 999,
      marginHorizontal: "5%",
      marginTop: 10,
      borderRadius: 15,
      elevation: 3,
      shadowColor: "#000",
      shadowOpacity: 0.1,
      shadowRadius: 5,
    },
    resultItem: {
      paddingVertical: 12,
      borderBottomWidth: 1,
      borderBottomColor: "#eee",
    },
    resultText: {
      fontSize: 18,
      fontWeight: "600",
    },
    resultSubText: {
      fontSize: 14,
      color: "gray",
    },
})