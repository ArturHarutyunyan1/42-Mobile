import { View, Button, Text, StyleSheet, ViewStyle, TouchableOpacity } from "react-native";

type BtnProps = {
    title: string,
    style?: ViewStyle
}

export default function Btn(props: BtnProps)
{
    return (
        <TouchableOpacity style={StyleSheet.flatten([styles.button, props.style])}>
            <View>
                <Text style={styles.text}>{props.title}</Text>
            </View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    number:
    {
        backgroundColor: "red"
    },
    button:
    {
        width: "25%",
        height: "25%",
        backgroundColor: "red",
        overflow: "hidden",
        borderRadius: 5,
        marginTop: 5,
    },
    text:
    {
        fontSize: 36
    }
})