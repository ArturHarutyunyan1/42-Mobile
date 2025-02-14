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

export default function Index() {
  const [pageIndex, setPageIndex] = useState(0);
  const [name, setName] = useState("");
  const pagerRef = useRef<PagerView>(null);

  const { location, error } = useLocation();
  const showError = error && (!name || name == "");
  return (
    <SafeAreaProvider>
      <AppBar setCityName={(name: string) => setCityName(name, setName)} />
      
      {}
      {showError && (
        <View
          style={{
            position: "absolute",
            top: 130,
            width: "100%",
            backgroundColor: "red",
            padding: 10,
            zIndex: 1000,
          }}
        >
          <Text style={{ fontSize: 20, color: "white" }}>
            Error: {error}
          </Text>
        </View>
      )}

      <PagerView
        ref={pagerRef}
        style={{ flex: 1 }}
        onPageSelected={(e) => setPageIndex(e.nativeEvent.position)}
      >
        <View key="1" style={{ justifyContent: "center", alignItems: "center" }}>
          <Text style={{ fontSize: 50 }}>{name || ""}</Text>
          <Text style={{ fontSize: 50 }}>Currently</Text>
          {location ? (
            <>
              <Text style={{ fontSize: 20 }}>Latitude: {location.lat}</Text>
              <Text style={{ fontSize: 20 }}>Longitude: {location.lon}</Text>
            </>
          ) : null}
        </View>
        <View key="2" style={{ justifyContent: "center", alignItems: "center" }}>
          <Today cityName={name} lat={location?.lat} log={location?.lon} />
        </View>
        <View key="3" style={{ justifyContent: "center", alignItems: "center" }}>
          <Weekly cityName={name} lat={location?.lat} log={location?.lon} />
        </View>
      </PagerView>
      <BottomBar onTabPress={(index) => changePage(index, pagerRef, setPageIndex)} />
    </SafeAreaProvider>
  );
}
