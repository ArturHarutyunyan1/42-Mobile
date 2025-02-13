import { Text, View, StyleSheet, Button } from "react-native";

export default function Index() {
  return (
    <View style={styles.wrapper}>
      <View style={styles.container}>
        <View style={styles.component}>
          <Text style={{fontSize: 20}}>A simple text</Text>
        </View>
        <Button title="Click me" onPress={() => console.log("Button pressed")}></Button>
      </  View>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper:
  {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    flex: 1    
  },
  container:
  {
    display: "flex",
    alignItems: "center",
    justifyContent: "center"
  },
  component:
  {
    width: 200,
    height: 70,
    borderRadius: 10,
    backgroundColor: "royalblue",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
  }
})