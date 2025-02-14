import { View, Text, ScrollView } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import AppBar from "@/components/AppBar";
import BottomBar from "@/components/BottomBar";
import PagerView from "react-native-pager-view";
import Today from "./today";
import Weekly from "./weekly";

export default function Index() {
  return (
    <SafeAreaProvider>
      <AppBar />
      <PagerView style={{ flex: 1 }} initialPage={0}>
      <View key="1">
        <Text>Currently</Text>
        </View>
        <View key="2">
          <Today></Today>
        </View>
        <View key="3">
          <Weekly></Weekly>
        </View>
      </PagerView>
      <BottomBar></BottomBar>
    </SafeAreaProvider>
  );
}
