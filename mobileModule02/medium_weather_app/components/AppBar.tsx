import { Stack } from "expo-router";
import { StyleSheet, View, Text, TextInput, Keyboard, TouchableOpacity } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { FontAwesomeIcon } from '@fortawesome/react-native-fontawesome'
import { faMagnifyingGlass, faLocationArrow } from '@fortawesome/free-solid-svg-icons';
import { useState } from "react";

type handler = {
    setCityName: (name: string) => void;
}

export default function AppBar({setCityName}: handler) {
    const [message, sendMessage] = useState("");

    const handleSubmit = () => {
        setCityName(message);
        Keyboard.dismiss();
        
    }
    return (
        <SafeAreaView>
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
        </SafeAreaView>
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