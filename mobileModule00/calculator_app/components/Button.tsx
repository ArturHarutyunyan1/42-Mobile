import { View, Text, StyleSheet, ViewStyle, TouchableOpacity, TextStyle } from "react-native";
import Display from "./Display";

type BtnProps = {
    title: string,
    style?: ViewStyle,
    textStyle?: TextStyle,
    onPress: () => void;
}

export default function Btn(props: BtnProps)
{
    return (
        <TouchableOpacity style={StyleSheet.flatten([styles.button, props.style])} onPress={props.onPress}>
            <View>
                <Text style={StyleSheet.flatten([styles.text, props.textStyle])}>{props.title}</Text>
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
        fontSize: 36,
        color: "#4E4D4D"
    }
})