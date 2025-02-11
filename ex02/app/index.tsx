import { Text, View, StyleSheet } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import Header from "@/components/header";
import Display from "@/components/Display";
export default function Index() {
  return (
    <SafeAreaProvider>
      <Header></Header>
      <View style={styles.wrapper}>
        <Display></Display>
          <View style={styles.buttons}></View>
      </View>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  wrapper:
  {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    flex: 1
  },
  buttons:
  {
    width: "90%",
    height: "70%",
    backgroundColor: "blue",
  },
})