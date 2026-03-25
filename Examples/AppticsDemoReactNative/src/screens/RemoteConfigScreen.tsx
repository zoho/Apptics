import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Switch,
  Alert,
} from 'react-native';
import {Apptics, AppticsRemoteConfig} from '@zoho_apptics/apptics-react-native';

export default function RemoteConfigScreen() {
  const [paramKey, setParamKey] = useState('welcome_message');
  const [coldFetch, setColdFetch] = useState(false);
  const [fallback, setFallback] = useState(true);
  const [result, setResult] = useState<string | null>(null);
  const [conditionKey, setConditionKey] = useState('user_type');
  const [conditionValue, setConditionValue] = useState('premium');

  useEffect(() => {
    Apptics.screenAttached('RemoteConfigScreen');
    return () => {
      Apptics.screenDetached('RemoteConfigScreen');
    };
  }, []);

  const fetchValue = async () => {
    try {
      const value = await AppticsRemoteConfig.getStringValue(
        paramKey.trim(),
        coldFetch,
        fallback,
      );
      setResult(value ?? '(null — param not found or not configured)');
      Apptics.addEvent('remote_config_fetched', 'RemoteConfig', {
        param: paramKey.trim(),
        cold_fetch: String(coldFetch),
      });
    } catch (e: any) {
      Alert.alert('Error', e?.message ?? 'Failed to fetch remote config');
    }
  };

  const setCondition = () => {
    if (!conditionKey.trim() || !conditionValue.trim()) {
      Alert.alert('Error', 'Both condition key and value are required.');
      return;
    }
    AppticsRemoteConfig.setCustomCondition(conditionKey.trim(), conditionValue.trim());
    Apptics.addEvent('remote_config_condition_set', 'RemoteConfig', {
      key: conditionKey.trim(),
      value: conditionValue.trim(),
    });
    Alert.alert('Condition Set', `${conditionKey} = ${conditionValue}`);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            Configure parameters in the Apptics console. Use{' '}
            <Text style={styles.code}>getStringValue()</Text> to fetch values.
            Cold fetch is limited to 3 calls/minute.
          </Text>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Fetch Parameter</Text>
          <Text style={styles.label}>Parameter Key</Text>
          <TextInput
            style={styles.input}
            value={paramKey}
            onChangeText={setParamKey}
            placeholder="e.g. welcome_message"
          />

          <View style={styles.toggleRow}>
            <Text style={styles.toggleLabel}>Cold Fetch (skip cache)</Text>
            <Switch value={coldFetch} onValueChange={setColdFetch} />
          </View>

          <View style={styles.toggleRow}>
            <Text style={styles.toggleLabel}>Fallback with Offline Value</Text>
            <Switch value={fallback} onValueChange={setFallback} />
          </View>

          <TouchableOpacity style={styles.btn} onPress={fetchValue}>
            <Text style={styles.btnText}>Fetch Value</Text>
          </TouchableOpacity>

          {result !== null && (
            <View style={styles.resultBox}>
              <Text style={styles.resultLabel}>Result:</Text>
              <Text style={styles.resultValue}>{result}</Text>
            </View>
          )}
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Set Custom Condition</Text>
          <Text style={styles.description}>
            Define device-specific conditions for targeted config delivery.
          </Text>
          <Text style={styles.label}>Condition Key</Text>
          <TextInput
            style={styles.input}
            value={conditionKey}
            onChangeText={setConditionKey}
            placeholder="e.g. user_type"
          />
          <Text style={styles.label}>Condition Value</Text>
          <TextInput
            style={styles.input}
            value={conditionValue}
            onChangeText={setConditionValue}
            placeholder="e.g. premium"
          />
          <TouchableOpacity
            style={[styles.btn, {backgroundColor: '#FF8C00'}]}
            onPress={setCondition}>
            <Text style={styles.btnText}>Set Condition</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
  infoBox: {
    backgroundColor: '#FFF7ED',
    borderRadius: 10,
    padding: 14,
    marginBottom: 16,
  },
  infoText: {fontSize: 13, color: '#92400E', lineHeight: 20},
  code: {fontFamily: 'monospace', backgroundColor: '#FED7AA', paddingHorizontal: 3},
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
  sectionTitle: {fontSize: 15, fontWeight: '700', color: '#1A1A2E', marginBottom: 10},
  label: {fontSize: 13, color: '#6B7280', marginBottom: 4, marginTop: 8},
  input: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
    color: '#1A1A2E',
  },
  toggleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#F3F4F6',
  },
  toggleLabel: {fontSize: 14, color: '#374151'},
  description: {fontSize: 13, color: '#374151', marginBottom: 8},
  btn: {
    backgroundColor: '#4A90E2',
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
    marginTop: 12,
  },
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
  resultBox: {
    marginTop: 12,
    backgroundColor: '#F0FDF4',
    borderRadius: 8,
    padding: 12,
    borderLeftWidth: 3,
    borderLeftColor: '#50C878',
  },
  resultLabel: {fontSize: 12, color: '#065F46', fontWeight: '600', marginBottom: 4},
  resultValue: {fontSize: 14, color: '#1A1A2E'},
});
