import React, {useEffect} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import {Apptics} from '@zoho_apptics/apptics-react-native';
import type {NativeStackNavigationProp} from '@react-navigation/native-stack';
import type {RootStackParamList} from '../navigation/types';

type Props = {
  navigation: NativeStackNavigationProp<RootStackParamList, 'Home'>;
};

const MENU_ITEMS = [
  {label: 'In-App Events', route: 'Events', color: '#4A90E2'},
  {label: 'Screen Tracking', route: 'Screens', color: '#7B68EE'},
  {label: 'Crash Reporting', route: 'Crash', color: '#E25C5C'},
  {label: 'In-App Updates', route: 'Updates', color: '#50C878'},
  {label: 'Remote Config', route: 'RemoteConfig', color: '#FF8C00'},
  {label: 'Remote Logger', route: 'RemoteLogger', color: '#20B2AA'},
  {label: 'Privacy Settings', route: 'Privacy', color: '#8B5CF6'},
  {label: 'Push Notifications', route: 'Push', color: '#06B6D4'},
] as const;

export default function HomeScreen({navigation}: Props) {
  useEffect(() => {
    Apptics.screenAttached('HomeScreen');
    return () => {
      Apptics.screenDetached('HomeScreen');
    };
  }, []);

  const handleNavigation = (route: (typeof MENU_ITEMS)[number]['route']) => {
    Apptics.addEvent('menu_item_tapped', 'Navigation', {destination: route});
    navigation.navigate(route as any);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.header}>
          <Text style={styles.title}>Apptics Demo</Text>
          <Text style={styles.subtitle}>React Native Integration</Text>
        </View>

        {MENU_ITEMS.map(item => (
          <TouchableOpacity
            key={item.route}
            style={[styles.card, {borderLeftColor: item.color}]}
            onPress={() => handleNavigation(item.route)}
            activeOpacity={0.7}>
            <View style={[styles.dot, {backgroundColor: item.color}]} />
            <Text style={styles.cardText}>{item.label}</Text>
            <Text style={styles.arrow}>›</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
  header: {marginBottom: 28, alignItems: 'center'},
  title: {fontSize: 28, fontWeight: '700', color: '#1A1A2E'},
  subtitle: {fontSize: 14, color: '#6B7280', marginTop: 4},
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 18,
    marginBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    borderLeftWidth: 4,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 2,
  },
  dot: {width: 10, height: 10, borderRadius: 5, marginRight: 14},
  cardText: {flex: 1, fontSize: 16, fontWeight: '600', color: '#1A1A2E'},
  arrow: {fontSize: 22, color: '#9CA3AF'},
});
