import { Text, View, StyleSheet, Dimensions } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import Header from "@/components/header";
import Display from "@/components/Display";
import Btn from "@/components/Button";

const screenWidth = Dimensions.get("window").width;
const screenHeight = Dimensions.get("window").height;

export default function Index() {
  return (
    <SafeAreaProvider>
      <Header></Header>
      <View style={styles.wrapper}>
        <Display></Display>
          <View style={styles.buttons}>
            <Btn title="C" style={[styles.digit, styles.clear]} textStyle={styles.clear}></Btn>
            <Btn title="()" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="%" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="/" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="7" style={styles.digit}></Btn>
            <Btn title="8" style={styles.digit}></Btn>
            <Btn title="9" style={styles.digit}></Btn>
            <Btn title="x" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="4" style={styles.digit}></Btn>
            <Btn title="5" style={styles.digit}></Btn>
            <Btn title="6" style={styles.digit}></Btn>
            <Btn title="-" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="1" style={styles.digit}></Btn>
            <Btn title="2" style={styles.digit}></Btn>
            <Btn title="3" style={styles.digit}></Btn>
            <Btn title="+" style={[styles.digit, styles.operator]} textStyle={styles.operator}></Btn>
            <Btn title="+/-" style={styles.digit}></Btn>
            <Btn title="0" style={styles.digit}></Btn>
            <Btn title="." style={styles.digit}></Btn>
            <Btn title="=" style={[styles.digit, styles.equal]} textStyle={styles.equal}></Btn>
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
    backgroundColor: "#f0f0f0",
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
    color: "#66FF7F"
  },
  equal:
  {
    backgroundColor: "#66FF7F",
    color: "white",
  }
});