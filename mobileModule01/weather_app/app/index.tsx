import { View, Text } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import AppBar from "@/components/AppBar";
import BottomBar from "@/components/BottomBar";
import PagerView from "react-native-pager-view";
import Today from "./today";
import Weekly from "./weekly";
import { useState, useRef } from "react";

export default function Index() {
  const [pageIndex, setPageIndex] = useState(0);
  const pagerRef = useRef(null);

  const changePage = (index: number) => {
    setPageIndex(index);
    if (pagerRef.current) {
      pagerRef.current.setPage(index);
    }
  };

  return (
    <SafeAreaProvider>
      <AppBar />
      <PagerView
        ref={pagerRef}
        style={{ flex: 1 }}
        onPageSelected={(e) => setPageIndex(e.nativeEvent.position)} // Track the current page index
      >
        <View key="1">
          <Text>Currently</Text>
        </View>
        <View key="2">
          <Today />
        </View>
        <View key="3">
          <Weekly />
        </View>
      </PagerView>
      <BottomBar onTabPress={changePage} />
    </SafeAreaProvider>
  );
}
