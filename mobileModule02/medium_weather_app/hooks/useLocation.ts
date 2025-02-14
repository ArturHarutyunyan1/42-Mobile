import { useState, useEffect } from "react";
import * as Location from 'expo-location';

type LocationData = {
  lat: number;
  lon: number;
};

type ErrorData = string | null;

export const useLocation = () => {
  const [location, setLocation] = useState<LocationData | null>(null);
  const [error, setError] = useState<ErrorData>(null);

  useEffect(() => {
    (async () => {
      let { status } = await Location.requestForegroundPermissionsAsync();
      if (status === 'granted') {
        let loc = await Location.getCurrentPositionAsync({});
        setLocation({ lat: loc.coords.latitude, lon: loc.coords.longitude });
      } else {
        setError("Permission denied, please enable it in settings in order to make the app work");
      }
    })();
  }, []);

  return { location, error };
};
