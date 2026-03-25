import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Alert,
} from 'react-native';
import {Apptics} from '@zoho_apptics/apptics-react-native';

export default function EventsScreen() {
  const [eventName, setEventName] = useState('button_clicked');
  const [groupName, setGroupName] = useState('UserActions');
  const [propKey, setPropKey] = useState('plan');
  const [propValue, setPropValue] = useState('premium');
  const [log, setLog] = useState<string[]>([]);

  useEffect(() => {
    Apptics.screenAttached('EventsScreen');
    return () => {
      Apptics.screenDetached('EventsScreen');
    };
  }, []);

  const addLog = (msg: string) =>
    setLog(prev => [`[${new Date().toLocaleTimeString()}] ${msg}`, ...prev.slice(0, 9)]);

  const logSimpleEvent = () => {
    Apptics.addEvent(eventName, groupName, {});
    addLog(`Event: "${eventName}" in group "${groupName}"`);
    Alert.alert('Event Logged', `"${eventName}" sent to Apptics`);
  };

  const logEventWithProps = () => {
    const props: Record<string, string> = {[propKey]: propValue};
    Apptics.addEvent(eventName, groupName, props);
    addLog(`Event with props: ${JSON.stringify(props)}`);
    Alert.alert('Event Logged', `"${eventName}" with props sent to Apptics`);
  };

  const logPresetEvents = () => {
    Apptics.addEvent('purchase_completed', 'Ecommerce', {
      item: 'Pro_Plan',
      amount: '9.99',
    });
    Apptics.addEvent('user_signed_up', 'Auth', {});
    Apptics.addEvent('feature_used', 'Engagement', {feature: 'dark_mode'});
    addLog('3 preset events logged');
    Alert.alert('Events Logged', '3 preset events sent to Apptics');
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <Text style={styles.sectionTitle}>Simple Event</Text>
        <View style={styles.card}>
          <Text style={styles.label}>Event Name</Text>
          <TextInput
            style={styles.input}
            value={eventName}
            onChangeText={setEventName}
            placeholder="e.g. button_clicked"
          />
          <Text style={styles.label}>Group Name</Text>
          <TextInput
            style={styles.input}
            value={groupName}
            onChangeText={setGroupName}
            placeholder="e.g. UserActions"
          />
          <TouchableOpacity style={styles.btn} onPress={logSimpleEvent}>
            <Text style={styles.btnText}>Log Simple Event</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.sectionTitle}>Event with Properties</Text>
        <View style={styles.card}>
          <Text style={styles.label}>Property Key</Text>
          <TextInput
            style={styles.input}
            value={propKey}
            onChangeText={setPropKey}
            placeholder="e.g. plan"
          />
          <Text style={styles.label}>Property Value</Text>
          <TextInput
            style={styles.input}
            value={propValue}
            onChangeText={setPropValue}
            placeholder="e.g. premium"
          />
          <TouchableOpacity
            style={[styles.btn, {backgroundColor: '#7B68EE'}]}
            onPress={logEventWithProps}>
            <Text style={styles.btnText}>Log Event with Props</Text>
          </TouchableOpacity>
        </View>

        <TouchableOpacity
          style={[styles.btn, {backgroundColor: '#50C878', marginBottom: 20}]}
          onPress={logPresetEvents}>
          <Text style={styles.btnText}>Log 3 Preset Events</Text>
        </TouchableOpacity>

        {log.length > 0 && (
          <View style={styles.logBox}>
            <Text style={styles.logTitle}>Activity Log</Text>
            {log.map((entry, i) => (
              <Text key={i} style={styles.logEntry}>
                {entry}
              </Text>
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
  sectionTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#1A1A2E',
    marginBottom: 10,
    marginTop: 8,
  },
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
  label: {fontSize: 13, color: '#6B7280', marginBottom: 4, marginTop: 8},
  input: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
    color: '#1A1A2E',
  },
  btn: {
    backgroundColor: '#4A90E2',
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
    marginTop: 12,
  },
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
  logBox: {
    backgroundColor: '#1A1A2E',
    borderRadius: 12,
    padding: 14,
  },
  logTitle: {color: '#9CA3AF', fontSize: 12, marginBottom: 8, fontWeight: '600'},
  logEntry: {color: '#E5E7EB', fontSize: 12, marginBottom: 4, fontFamily: 'monospace'},
});
