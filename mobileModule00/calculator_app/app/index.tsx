import { View, StyleSheet, Dimensions } from "react-native";
import { useState } from "react";
import { SafeAreaProvider } from "react-native-safe-area-context";
import Header from "@/components/header";
import Display from "@/components/Display";
import Btn from "@/components/Button";
import { handlePress } from "./functions/logic";

const screenWidth = Dimensions.get("window").width;
const screenHeight = Dimensions.get("window").height;

export default function Index() {
  const [input, setInput] = useState("");

  return (
    <SafeAreaProvider>
      <Header></Header>
      <View style={styles.wrapper}>
        <Display input={input}></Display>
        <View style={styles.buttons}>
          {["AC", "()", "/", "C", "7", "8", "9", "*", "4", "5", "6", "-", "1", "2", "3", "+", "+/-", "0", ".", "="].map(title => (
            <Btn
              key={title}
              title={title}
              onPress={() => handlePress(title, input, setInput)}
              style={[styles.digit, title === "=" ? styles.equal : title === "C" || title === "AC" ? styles.clear : undefined]}
              textStyle={title === "=" || title === "C"}
            />
          ))}
        </View>
      </View>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    justifyContent: "space-between",
    alignItems: "center",
  },
  buttons: {
    flexDirection: "row",
    flexWrap: "wrap",
    width: "90%",
    height: "70%",
    justifyContent: "space-between",
    paddingHorizontal: 5,
  },
  digit: {
    width: screenWidth * 0.20,
    height: (screenHeight * 0.5) / 5.5,
    backgroundColor: "#e0e0e0",
    color: "#4E4D4D",
    justifyContent: "center",
    alignItems: "center",
    borderRadius: 5,
  },
  clear:
  {
    backgroundColor: "#FF5959",
    color: "white",
  },
  operator:
  {
    color: "#4C6A92"
  },
  equal:
  {
    backgroundColor: "#66FF7F",
    color: "white",
  }
});
