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
import {Apptics, APLogger, APLogLevel} from '@zoho_apptics/apptics-react-native';

type LogEntry = {level: string; message: string; time: string; color: string};

const LOG_LEVELS = [
  {label: 'Verbose', method: 'log', color: '#6B7280'},
  {label: 'Debug', method: 'debug', color: '#4A90E2'},
  {label: 'Info', method: 'info', color: '#50C878'},
  {label: 'Warn', method: 'warn', color: '#FF8C00'},
  {label: 'Error', method: 'error', color: '#E25C5C'},
] as const;

export default function RemoteLoggerScreen() {
  const [isEnabled, setIsEnabled] = useState(false);
  const [message, setMessage] = useState('Test log message');
  const [logHistory, setLogHistory] = useState<LogEntry[]>([]);

  useEffect(() => {
    Apptics.screenAttached('RemoteLoggerScreen');
    return () => {
      Apptics.screenDetached('RemoteLoggerScreen');
    };
  }, []);

  const toggleLogger = () => {
    if (isEnabled) {
      APLogger.disable();
      setIsEnabled(false);
      Alert.alert('Remote Logger', 'Logger disabled.');
    } else {
      APLogger.enable();
      setIsEnabled(true);
      Alert.alert('Remote Logger', 'Logger enabled.');
    }
    Apptics.addEvent('remote_logger_toggled', 'Logger', {
      enabled: String(!isEnabled),
    });
  };

  const now = () => new Date().toLocaleTimeString();

  const sendLog = (level: (typeof LOG_LEVELS)[number]) => {
    const props = {screen: 'RemoteLoggerScreen'};
    switch (level.method) {
      case 'log':
        APLogger.log(message, ['tag1', 'tag2'], props);
        break;
      case 'debug':
        APLogger.debug(message);
        break;
      case 'info':
        APLogger.info(message);
        break;
      case 'warn':
        APLogger.warn(message);
        break;
      case 'error':
        APLogger.error(message);
        break;
    }
    setLogHistory(prev => [
      {level: level.label, message, time: now(), color: level.color},
      ...prev.slice(0, 14),
    ]);
  };

  const sendAllLevels = () => {
    APLogger.log('Verbose: all systems nominal', ['demo'], {source: 'demo'});
    APLogger.debug('Debug: checking state');
    APLogger.info('Info: user action recorded');
    APLogger.warn('Warn: low memory detected');
    APLogger.error('Error: network timeout');
    setLogHistory(prev => [
      {level: 'Error', message: 'Error: network timeout', time: now(), color: '#E25C5C'},
      {level: 'Warn', message: 'Warn: low memory detected', time: now(), color: '#FF8C00'},
      {level: 'Info', message: 'Info: user action recorded', time: now(), color: '#50C878'},
      {level: 'Debug', message: 'Debug: checking state', time: now(), color: '#4A90E2'},
      {level: 'Verbose', message: 'Verbose: all systems nominal', time: now(), color: '#6B7280'},
      ...prev.slice(0, 9),
    ]);
    Alert.alert('Done', '5 logs sent across all levels.');
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            Logs are sent to Apptics only from{' '}
            <Text style={styles.bold}>release builds</Text>. In debug builds
            they are printed to the console only.
          </Text>
        </View>

        <View style={styles.card}>
          <View style={styles.toggleRow}>
            <View>
              <Text style={styles.sectionTitle}>Remote Logger</Text>
              <Text style={styles.statusText}>
                Status:{' '}
                <Text
                  style={{
                    color: isEnabled ? '#50C878' : '#E25C5C',
                    fontWeight: '700',
                  }}>
                  {isEnabled ? 'Enabled' : 'Disabled'}
                </Text>
              </Text>
            </View>
            <TouchableOpacity
              style={[
                styles.toggleBtn,
                {backgroundColor: isEnabled ? '#E25C5C' : '#50C878'},
              ]}
              onPress={toggleLogger}>
              <Text style={styles.toggleBtnText}>
                {isEnabled ? 'Disable' : 'Enable'}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Send Log</Text>
          <Text style={styles.label}>Message</Text>
          <TextInput
            style={styles.input}
            value={message}
            onChangeText={setMessage}
            placeholder="Enter log message"
          />
          <View style={styles.levelGrid}>
            {LOG_LEVELS.map(level => (
              <TouchableOpacity
                key={level.method}
                style={[styles.levelBtn, {borderColor: level.color}]}
                onPress={() => sendLog(level)}>
                <Text style={[styles.levelBtnText, {color: level.color}]}>
                  {level.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
          <TouchableOpacity
            style={[styles.btn, {backgroundColor: '#20B2AA', marginTop: 8}]}
            onPress={sendAllLevels}>
            <Text style={styles.btnText}>Send All Levels</Text>
          </TouchableOpacity>
        </View>

        {logHistory.length > 0 && (
          <View style={styles.logBox}>
            <Text style={styles.logTitle}>Log History</Text>
            {logHistory.map((entry, i) => (
              <View key={i} style={styles.logRow}>
                <Text style={[styles.logLevel, {color: entry.color}]}>
                  [{entry.level}]
                </Text>
                <Text style={styles.logMsg} numberOfLines={1}>
                  {entry.message}
                </Text>
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
    backgroundColor: '#F0F9FF',
    borderRadius: 10,
    padding: 14,
    marginBottom: 16,
  },
  infoText: {fontSize: 13, color: '#0C4A6E', lineHeight: 20},
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
  toggleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  sectionTitle: {fontSize: 15, fontWeight: '700', color: '#1A1A2E', marginBottom: 2},
  statusText: {fontSize: 13, color: '#6B7280'},
  toggleBtn: {
    borderRadius: 8,
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  toggleBtnText: {color: '#FFF', fontWeight: '600', fontSize: 14},
  label: {fontSize: 13, color: '#6B7280', marginBottom: 4, marginTop: 8},
  input: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 8,
    padding: 10,
    fontSize: 14,
    color: '#1A1A2E',
    marginBottom: 12,
  },
  levelGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  levelBtn: {
    borderWidth: 1.5,
    borderRadius: 8,
    paddingHorizontal: 14,
    paddingVertical: 8,
  },
  levelBtnText: {fontWeight: '600', fontSize: 13},
  btn: {
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
  logRow: {flexDirection: 'row', alignItems: 'center', marginBottom: 6},
  logLevel: {fontSize: 11, fontWeight: '700', marginRight: 6, fontFamily: 'monospace', width: 70},
  logMsg: {flex: 1, color: '#E5E7EB', fontSize: 11},
  logTime: {color: '#6B7280', fontSize: 10, marginLeft: 4},
});
