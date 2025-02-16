import { Stack } from "expo-router";
import { StyleSheet, View, Text, TextInput, Keyboard, TouchableOpacity, FlatList } from "react-native";
import { FontAwesomeIcon } from "@fortawesome/react-native-fontawesome";
import { faMagnifyingGlass, faLocationArrow } from "@fortawesome/free-solid-svg-icons";
import { useState, useCallback } from "react";
import { debounce } from "lodash";
import { GEOCODING_API } from "@env";

type Handler = {
  setCityName: (name: string) => void;
};

interface LocationData {
  name: string;
  country?: string;
  country_code?: string;
  latitude?: number;
  longitude?: number;
}

export default function AppBar({ setCityName }: Handler) {
  const [message, sendMessage] = useState("");
  const [searchResults, setSearchResults] = useState<LocationData[]>([]);
  const [isSet, set] = useState(false);

  const handleSubmit = useCallback(
    debounce(async (query: string) => {
      if (!query.trim()) {
        setSearchResults([]);
        set(false);
        return;
      }

      try {
        const apiUrl = `${GEOCODING_API}?name=${query}`;
        console.log("Fetching:", apiUrl);

        const res = await fetch(apiUrl);
        if (!res.ok) throw new Error("Failed to fetch data");

        const jsonData = await res.json();

        if (jsonData.results && jsonData.results.length > 0) {
          setSearchResults(jsonData.results);
          set(true);
        } else {
          setSearchResults([]);
        }
      } catch (error) {
        console.log("ERROR Occurred:", error);
        setSearchResults([]);
      }
    }, 500),
    []
  );

  const handleInputChange = (text: string) => {
    sendMessage(text);
    handleSubmit(text);
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
                    onChangeText={handleSubmit}
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
            {isSet == true && searchResults.length > 0 && (
            <View style={styles.searchResult}>
                <FlatList
                  data={searchResults}
                  keyExtractor={(item) => `${item.longitude}-${item.latitude}`}
                  renderItem={({ item }) => (
                    <TouchableOpacity style={styles.resultItem} activeOpacity={0.7}
                    onPress={() => setCityName(item.name)}
                    >
                      <Text style={styles.resultText}>{item.name}</Text>
                      <Text style={styles.resultSubText}>{item.country}, {item.country_code}</Text>
                    </TouchableOpacity>
                  )}
                />
            </View>
              )}
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