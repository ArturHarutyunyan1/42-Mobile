import { ScrollView, Text, View } from "react-native";
import AppBar from "@/components/AppBar";
import { SafeAreaProvider } from "react-native-safe-area-context";

export default function Index() {
  return (
    <SafeAreaProvider>
      <AppBar></AppBar>
      <ScrollView>
      </ScrollView>
    </SafeAreaProvider>
  );
}
