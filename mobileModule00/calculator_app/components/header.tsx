import { Stack } from "expo-router";
import { StyleSheet, View } from "react-native";

export default function Header()
{
    return (
        <View>
            <Stack screenOptions={{headerShown: false}}>
            </Stack>
            <Stack.Screen
                    options={{
                    headerShown: true,
                    title: 'Calculator',
                    headerStyle: styles.headerStyle,
                    headerTintColor: styles.headerTintColor.color,
                    headerTitleStyle: styles.headerTintStyle
                    }}
                />
        </View>
    );
}

const styles = StyleSheet.create({
    headerStyle:
    {
      backgroundColor: "royalblue",
    },
    headerTintColor:
    {
      color: "white"
    },
    headerTintStyle:
    {
      fontSize: 20
    },
})