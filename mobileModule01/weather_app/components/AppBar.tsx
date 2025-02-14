import { Stack } from "expo-router";
import { StyleSheet, View, Text, TextInput } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { FontAwesomeIcon } from '@fortawesome/react-native-fontawesome'
import { faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons';

export default function AppBar()
{
    return (
        <SafeAreaView>
            <Stack screenOptions={{headerShown: false}}></Stack>
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
                />
                <TextInput
                    placeholder="Search..."
                    style={styles.input}>
                </TextInput>
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
        height: 50,
        padding: 10,
        fontSize: 30
    }
})