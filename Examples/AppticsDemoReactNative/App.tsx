/**
 * Apptics Demo — React Native
 * Demonstrates Apptics SDK integration:
 *  - In-App Events
 *  - Screen Tracking
 *  - Crash Reporting
 *  - In-App Updates
 *  - Remote Config
 *  - Remote Logger
 *  - Privacy / Tracking Settings
 *  - Push Notifications
 */

import React, {useEffect} from 'react';
import {StatusBar, useColorScheme} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {Apptics, AppticsPushMessages} from '@zoho_apptics/apptics-react-native';

import HomeScreen from './src/screens/HomeScreen';
import EventsScreen from './src/screens/EventsScreen';
import ScreensScreen from './src/screens/ScreensScreen';
import CrashScreen from './src/screens/CrashScreen';
import UpdatesScreen from './src/screens/UpdatesScreen';
import RemoteConfigScreen from './src/screens/RemoteConfigScreen';
import RemoteLoggerScreen from './src/screens/RemoteLoggerScreen';
import PrivacyScreen from './src/screens/PrivacyScreen';
import PushNotificationsScreen from './src/screens/PushNotificationsScreen';
import type {RootStackParamList} from './src/navigation/types';

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function App() {
  const isDarkMode = useColorScheme() === 'dark';

  useEffect(() => {
    // Initialize Apptics SDK — must be called early in app lifecycle.
    // Ensure apptics-config.plist (iOS) and apptics-config.json (Android)
    // are placed in their respective native directories.
    Apptics.init();
    // Start push notification service. Native-side setup (entitlements,
    // capabilities, Firebase) is handled in the Xcode / Android project.
    AppticsPushMessages.startService();
  }, []);

  return (
    <SafeAreaProvider>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName="Home"
          screenOptions={{
            headerStyle: {backgroundColor: '#1A1A2E'},
            headerTintColor: '#FFFFFF',
            headerTitleStyle: {fontWeight: '700'},
          }}>
          <Stack.Screen
            name="Home"
            component={HomeScreen}
            options={{title: 'Apptics Demo'}}
          />
          <Stack.Screen
            name="Events"
            component={EventsScreen}
            options={{title: 'In-App Events'}}
          />
          <Stack.Screen
            name="Screens"
            component={ScreensScreen}
            options={{title: 'Screen Tracking'}}
          />
          <Stack.Screen
            name="Crash"
            component={CrashScreen}
            options={{title: 'Crash Reporting'}}
          />
          <Stack.Screen
            name="Updates"
            component={UpdatesScreen}
            options={{title: 'In-App Updates'}}
          />
          <Stack.Screen
            name="RemoteConfig"
            component={RemoteConfigScreen}
            options={{title: 'Remote Config'}}
          />
          <Stack.Screen
            name="RemoteLogger"
            component={RemoteLoggerScreen}
            options={{title: 'Remote Logger'}}
          />
          <Stack.Screen
            name="Privacy"
            component={PrivacyScreen}
            options={{title: 'Privacy Settings'}}
          />
          <Stack.Screen
            name="Push"
            component={PushNotificationsScreen}
            options={{title: 'Push Notifications'}}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
