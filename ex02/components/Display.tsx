import { StyleSheet, View, Text } from "react-native";

export default function Display()
{
    return (
        <View style={styles.display}>
            <View style={styles.components}>
                <View style={styles.input}>
                    <Text style={styles.inputFont}>2 + 7</Text>
                </View>
                <View style={styles.result}>
                    <Text style={styles.resultFont}>0</Text>
                </View>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    display:
    {
      width: "100%",
      height: "40%",
      justifyContent: "center",
      alignItems: "center",
    },
    components:
    {
        width: "90%",
        height: "80%",
        borderBottomWidth: 2,
        borderBottomColor: "black",
    },
    input:
    {
        width: "100%",
        height: "50%",
        paddingTop: 50,
        justifyContent: "flex-start",
        alignItems: "flex-end"
    },
    result:
    {
        width: "100%",
        height: "50%",
        paddingTop: 40,
        justifyContent: "flex-start",
        alignItems: "flex-end"
    },
    inputFont:
    {
        fontFamily: "Inter",
        fontSize: 50,
    },
    resultFont:
    {
        fontFamily: "Inter",
        fontSize: 50,
        color: "#747474",
    }
})