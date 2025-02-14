import { View, Text } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import AppBar from "@/components/AppBar";
import BottomBar from "@/components/BottomBar";
import PagerView from "react-native-pager-view";
import Today from "./today";
import Weekly from "./weekly";
import { useState, useRef } from "react";

type pageProps = {
  cityName?: string
}

export default function Index({cityName}: pageProps) {
  const [pageIndex, setPageIndex] = useState(0);
  const [name, setName] = useState("");
  const pagerRef = useRef<PagerView>(null);

  const changePage = (index: number) => {
    setPageIndex(index);
    if (pagerRef.current) {
      pagerRef.current.setPage(index);
    }
  };
  const setCityName = (name: string) => {
    setName(name);
  }
  return (
    <SafeAreaProvider>
      <AppBar setCityName={setCityName} />
      <PagerView
        ref={pagerRef}
        style={{ flex: 1 }}
        onPageSelected={(e) => setPageIndex(e.nativeEvent.position)}
      >
        <View key="1" style={{justifyContent: "center", alignItems: "center"}}>
        <Text style={{fontSize: 50}}>{name || ""}</Text>
        <Text style={{fontSize: 50}}>Currently</Text>
        </View>
        <View key="2" style={{justifyContent: "center", alignItems: "center"}}>
          <Today cityName={name || ""} />
        </View>
        <View key="3" style={{justifyContent: "center", alignItems: "center"}}>
          <Weekly cityName={name || ""} />
        </View>
      </PagerView>
      <BottomBar onTabPress={changePage} />
    </SafeAreaProvider>
  );
}
