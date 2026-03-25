import React, {useEffect} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Alert,
} from 'react-native';
import {Apptics} from '@zoho_apptics/apptics-react-native';

export default function CrashScreen() {
  useEffect(() => {
    // Initialize crash tracker — works only in release builds
    Apptics.initCrashTracker();
    Apptics.screenAttached('CrashScreen');
    return () => {
      Apptics.screenDetached('CrashScreen');
    };
  }, []);

  const triggerJSError = () => {
    Alert.alert(
      'Trigger JS Crash?',
      'This will throw a JS error to test crash reporting. Only captured in release builds.',
      [
        {text: 'Cancel', style: 'cancel'},
        {
          text: 'Trigger',
          style: 'destructive',
          onPress: () => {
            // Intentional crash for testing
            const obj: any = null;
            // eslint-disable-next-line @typescript-eslint/no-unused-expressions
            obj.nonExistentProperty;
          },
        },
      ],
    );
  };

  const triggerNativeError = () => {
    Alert.alert(
      'Trigger Native Crash?',
      'This will throw a native error. Only captured in release builds.',
      [
        {text: 'Cancel', style: 'cancel'},
        {
          text: 'Trigger',
          style: 'destructive',
          onPress: () => {
            throw new Error('Test native crash from Apptics Demo');
          },
        },
      ],
    );
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.warningBox}>
          <Text style={styles.warningIcon}>⚠️</Text>
          <Text style={styles.warningText}>
            Crash reporting only works in{' '}
            <Text style={styles.bold}>release builds</Text>. Crashes in debug
            builds are only logged to the console.
          </Text>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Setup</Text>
          <View style={styles.codeBlock}>
            <Text style={styles.codeText}>
              {'import { Apptics } from \'@zoho_apptics/apptics-react-native\';\n\n'}
              {'useEffect(() => {\n'}
              {'  Apptics.initCrashTracker();\n'}
              {'}, []);'}
            </Text>
          </View>
          <Text style={styles.hint}>
            Already called in this screen's useEffect.
          </Text>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Source Map Upload</Text>
          <Text style={styles.description}>
            To symbolicate crash reports:
          </Text>
          {[
            '1. Bundle your app for release',
            '2. Compress the .map file into a .zip',
            '3. Go to Quality → Symbols & Mapping',
            '4. Select "ReactNative source maps"',
            '5. Upload your zipped .map file',
          ].map((step, i) => (
            <Text key={i} style={styles.step}>
              {step}
            </Text>
          ))}
        </View>

        <TouchableOpacity style={[styles.btn, styles.btnDanger]} onPress={triggerJSError}>
          <Text style={styles.btnText}>Trigger JS Error (Release only)</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.btn, styles.btnDanger, {marginTop: 10}]}
          onPress={triggerNativeError}>
          <Text style={styles.btnText}>Trigger Native Error (Release only)</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
  warningBox: {
    backgroundColor: '#FEF3C7',
    borderRadius: 10,
    padding: 14,
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  warningIcon: {fontSize: 18, marginRight: 10},
  warningText: {flex: 1, fontSize: 13, color: '#92400E', lineHeight: 20},
  bold: {fontWeight: '700'},
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
  sectionTitle: {
    fontSize: 15,
    fontWeight: '700',
    color: '#1A1A2E',
    marginBottom: 10,
  },
  codeBlock: {
    backgroundColor: '#1A1A2E',
    borderRadius: 8,
    padding: 12,
    marginBottom: 8,
  },
  codeText: {color: '#E5E7EB', fontSize: 12, fontFamily: 'monospace'},
  hint: {fontSize: 12, color: '#6B7280'},
  description: {fontSize: 13, color: '#374151', marginBottom: 8},
  step: {
    fontSize: 13,
    color: '#374151',
    paddingVertical: 3,
    paddingLeft: 4,
  },
  btn: {
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
  },
  btnDanger: {backgroundColor: '#E25C5C'},
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
});
