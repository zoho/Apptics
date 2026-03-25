import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import {Apptics} from '@zoho_apptics/apptics-react-native';

type TrackedScreen = {
  name: string;
  state: 'attached' | 'detached';
  time: string;
};

export default function ScreensScreen() {
  const [screenName, setScreenName] = useState('ProductDetailScreen');
  const [tracked, setTracked] = useState<TrackedScreen[]>([]);

  useEffect(() => {
    Apptics.screenAttached('ScreensScreen');
    return () => {
      Apptics.screenDetached('ScreensScreen');
    };
  }, []);

  const now = () => new Date().toLocaleTimeString();

  const attachScreen = () => {
    if (!screenName.trim()) {return;}
    Apptics.screenAttached(screenName.trim());
    setTracked(prev => [
      {name: screenName.trim(), state: 'attached', time: now()},
      ...prev,
    ]);
  };

  const detachScreen = () => {
    if (!screenName.trim()) {return;}
    Apptics.screenDetached(screenName.trim());
    setTracked(prev => [
      {name: screenName.trim(), state: 'detached', time: now()},
      ...prev,
    ]);
  };

  const simulateFlow = () => {
    const screens = ['OnboardingScreen', 'LoginScreen', 'DashboardScreen'];
    screens.forEach((s, i) => {
      setTimeout(() => {
        Apptics.screenAttached(s);
        setTracked(prev => [{name: s, state: 'attached', time: now()}, ...prev]);
        setTimeout(() => {
          Apptics.screenDetached(s);
          setTracked(prev => [{name: s, state: 'detached', time: now()}, ...prev]);
        }, 500);
      }, i * 800);
    });
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            Call <Text style={styles.code}>screenAttached()</Text> when a screen
            appears and <Text style={styles.code}>screenDetached()</Text> when it
            disappears. This screen is already being tracked.
          </Text>
        </View>

        <View style={styles.card}>
          <Text style={styles.label}>Screen Name</Text>
          <TextInput
            style={styles.input}
            value={screenName}
            onChangeText={setScreenName}
            placeholder="e.g. ProductDetailScreen"
          />
          <View style={styles.row}>
            <TouchableOpacity
              style={[styles.btn, {backgroundColor: '#50C878', flex: 1, marginRight: 8}]}
              onPress={attachScreen}>
              <Text style={styles.btnText}>Attach</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.btn, {backgroundColor: '#E25C5C', flex: 1}]}
              onPress={detachScreen}>
              <Text style={styles.btnText}>Detach</Text>
            </TouchableOpacity>
          </View>
        </View>

        <TouchableOpacity
          style={[styles.btn, {backgroundColor: '#7B68EE', marginBottom: 20}]}
          onPress={simulateFlow}>
          <Text style={styles.btnText}>Simulate 3-Screen Flow</Text>
        </TouchableOpacity>

        {tracked.length > 0 && (
          <View style={styles.logBox}>
            <Text style={styles.logTitle}>Screen Tracking Log</Text>
            {tracked.slice(0, 12).map((entry, i) => (
              <View key={i} style={styles.logRow}>
                <View
                  style={[
                    styles.badge,
                    {
                      backgroundColor:
                        entry.state === 'attached' ? '#D1FAE5' : '#FEE2E2',
                    },
                  ]}>
                  <Text
                    style={[
                      styles.badgeText,
                      {
                        color:
                          entry.state === 'attached' ? '#065F46' : '#991B1B',
                      },
                    ]}>
                    {entry.state}
                  </Text>
                </View>
                <Text style={styles.logName}>{entry.name}</Text>
                <Text style={styles.logTime}>{entry.time}</Text>
              </View>
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
  infoBox: {
    backgroundColor: '#EFF6FF',
    borderRadius: 10,
    padding: 14,
    marginBottom: 16,
  },
  infoText: {fontSize: 13, color: '#1E40AF', lineHeight: 20},
  code: {fontFamily: 'monospace', backgroundColor: '#DBEAFE', paddingHorizontal: 4},
  card: {
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 2,
  },
  label: {fontSize: 13, color: '#6B7280', marginBottom: 4},
  input: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
    marginBottom: 12,
    color: '#1A1A2E',
  },
  row: {flexDirection: 'row'},
  btn: {
    backgroundColor: '#4A90E2',
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
  },
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
  logBox: {
    backgroundColor: '#1A1A2E',
    borderRadius: 12,
    padding: 14,
  },
  logTitle: {color: '#9CA3AF', fontSize: 12, marginBottom: 8, fontWeight: '600'},
  logRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  badge: {
    borderRadius: 6,
    paddingHorizontal: 8,
    paddingVertical: 2,
    marginRight: 8,
  },
  badgeText: {fontSize: 11, fontWeight: '600'},
  logName: {flex: 1, color: '#E5E7EB', fontSize: 12},
  logTime: {color: '#6B7280', fontSize: 11},
});
