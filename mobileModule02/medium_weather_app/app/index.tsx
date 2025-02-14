// src/screens/Index.tsx
import { View, Text } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import AppBar from "@/components/AppBar";
import BottomBar from "@/components/BottomBar";
import PagerView from "react-native-pager-view";
import Today from "./today";
import Weekly from "./weekly";
import { useState, useRef } from "react";
import { useLocation } from "@/hooks/useLocation";
import { changePage, setCityName } from "@/hooks/utils";

type locationProps = {
  lat: number;
};

export default function Index({ lat }: locationProps) {
  const [pageIndex, setPageIndex] = useState(0);
  const [name, setName] = useState("");
  const pagerRef = useRef<PagerView>(null);

  const { location, error } = useLocation();

  return (
    <SafeAreaProvider>
      <AppBar setCityName={(name: string) => setCityName(name, setName)} />
      <PagerView
        ref={pagerRef}
        style={{ flex: 1 }}
        onPageSelected={(e) => setPageIndex(e.nativeEvent.position)}
      >
        <View key="1" style={{ justifyContent: "center", alignItems: "center" }}>
          <Text style={{ fontSize: 50 }}>{name || ""}</Text>
          <Text style={{ fontSize: 50 }}>Currently</Text>
          <Text style={{ fontSize: 20 }}>
            Latitude: {location ? location.lat : error ? error : "Loading..."}
          </Text>
          <Text style={{ fontSize: 20 }}>
            Longitude: {location ? location.lon : error ? error : "Loading..."}
          </Text>
        </View>
        <View key="2" style={{ justifyContent: "center", alignItems: "center" }}>
          <Today cityName={lat} />
        </View>
        <View key="3" style={{ justifyContent: "center", alignItems: "center" }}>
          <Weekly cityName={name || ""} />
        </View>
      </PagerView>
      <BottomBar onTabPress={(index) => changePage(index, pagerRef, setPageIndex)} />
    </SafeAreaProvider>
  );
}
