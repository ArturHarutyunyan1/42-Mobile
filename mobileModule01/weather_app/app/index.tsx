import { View, Text } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import AppBar from "@/components/AppBar";
import PagerView from "react-native-pager-view";
import Today from "./today";
import Weekly from "./weekly";

export default function Index() {
  return (
    <SafeAreaProvider>
      <AppBar />
      <PagerView style={{ flex: 1 }} initialPage={1}>
      <View key="3" style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#f5f5f5" }}>
        <Weekly></Weekly>
        </View>
        <View key="1" style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#f5f5f5" }}>
          <Text style={{ fontSize: 24 }}>Home Page</Text>
        </View>
        <View key="2" style={{ flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#e0e0e0" }}>
          <Today></Today>
        </View>
      </PagerView>
    </SafeAreaProvider>
  );
}
