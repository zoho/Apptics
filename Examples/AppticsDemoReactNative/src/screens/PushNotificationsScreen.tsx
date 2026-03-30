import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Platform,
} from 'react-native';
import {
  Apptics,
  AppticsPushMessages,
  AppticsPushModuleEmitter,
  APNotificationOption,
} from '@zoho_apptics/apptics-react-native';

type PushEvent = {
  type: 'received' | 'click' | 'action';
  time: string;
  summary: string;
};

const FOREGROUND_OPTIONS: {label: string; value: APNotificationOption; desc: string}[] = [
  {
    label: 'All',
    value: APNotificationOption.all,
    desc: 'Banner + sound',
  },
  {
    label: 'Banner',
    value: APNotificationOption.banner,
    desc: 'Visual banner only',
  },
  {
    label: 'Sound',
    value: APNotificationOption.sound,
    desc: 'Sound only',
  },
  {
    label: 'None',
    value: APNotificationOption.none,
    desc: 'Silent / suppressed',
  },
];

const EVENT_COLORS: Record<PushEvent['type'], string> = {
  received: '#4A90E2',
  click: '#50C878',
  action: '#FF8C00',
};

export default function PushNotificationsScreen() {
  const [registered, setRegistered] = useState(false);
  const [foregroundOption, setForegroundOption] = useState<APNotificationOption>(
    APNotificationOption.all,
  );
  const [events, setEvents] = useState<PushEvent[]>([]);

  const now = () => new Date().toLocaleTimeString();

  const addEvent = (type: PushEvent['type'], summary: string) =>
    setEvents(prev => [{type, time: now(), summary}, ...prev.slice(0, 19)]);

  useEffect(() => {
    Apptics.screenAttached('PushNotificationsScreen');

    // Wire up push event callbacks via AppticsPushModuleEmitter
    AppticsPushModuleEmitter.onMessageReceived = payload => {
      addEvent('received', JSON.stringify(payload ?? {}));
    };

    AppticsPushModuleEmitter.onNotificationClick = (clickAction, payload) => {
      addEvent('click', `action="${clickAction}" payload=${JSON.stringify(payload ?? {})}`);
    };

    AppticsPushModuleEmitter.onNotificationActionClick = (
      actionId,
      clickAction,
      payload,
    ) => {
      addEvent(
        'action',
        `id="${actionId}" action="${clickAction}" payload=${JSON.stringify(payload ?? {})}`,
      );
    };

    return () => {
      // Clear callbacks on unmount to avoid memory leaks
      AppticsPushModuleEmitter.onMessageReceived = null;
      AppticsPushModuleEmitter.onNotificationClick = null;
      AppticsPushModuleEmitter.onNotificationActionClick = null;
      Apptics.screenDetached('PushNotificationsScreen');
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleRegister = () => {
    AppticsPushMessages.registerPushNotification();
    setRegistered(true);
    Apptics.addEvent('push_registration_requested', 'Push', {
      platform: Platform.OS,
    });
  };

  const handleForegroundOption = (option: APNotificationOption) => {
    setForegroundOption(option);
    AppticsPushMessages.setForegroundNotificationOptions(option);
    Apptics.addEvent('push_foreground_option_changed', 'Push', {
      option: String(option),
    });
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>

        {/* Registration */}
        {Platform.OS === 'ios' && (
          <View style={styles.card}>
          <View style={styles.cardHeader}>
            <Text style={styles.sectionTitle}>Push Registration</Text>
            {registered && (
              <View style={styles.badge}>
                <Text style={styles.badgeText}>Registered</Text>
              </View>
            )}
          </View>
          <Text style={styles.description}>
            Requests the OS permission prompt and registers the device token
            with Apptics.
          </Text>
          <TouchableOpacity
            style={[styles.btn, registered && styles.btnDisabled]}
            onPress={handleRegister}
            disabled={registered}>
            <Text style={styles.btnText}>
              {registered ? '✓ Registered' : 'Register Push Notifications'}
            </Text>
          </TouchableOpacity>
        </View>
        )}
        

        {/* Foreground options — iOS only */}
        {Platform.OS === 'ios' && (
          <View style={styles.card}>
            <Text style={styles.sectionTitle}>Foreground Display Options</Text>
            <Text style={styles.description}>
              Controls how notifications appear while the app is in the
              foreground.
            </Text>
            <View style={styles.optionGrid}>
              {FOREGROUND_OPTIONS.map(opt => {
                const active = foregroundOption === opt.value;
                return (
                  <TouchableOpacity
                    key={opt.value}
                    style={[styles.optionBtn, active && styles.optionBtnActive]}
                    onPress={() => handleForegroundOption(opt.value)}>
                    <Text
                      style={[
                        styles.optionLabel,
                        active && styles.optionLabelActive,
                      ]}>
                      {opt.label}
                    </Text>
                    <Text
                      style={[
                        styles.optionDesc,
                        active && styles.optionDescActive,
                      ]}>
                      {opt.desc}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
          </View>
        )}

        {/* Event log */}
        <View style={styles.card}>
          <View style={styles.cardHeader}>
            <Text style={styles.sectionTitle}>Event Log</Text>
            <View style={styles.legendRow}>
              {(Object.keys(EVENT_COLORS) as PushEvent['type'][]).map(t => (
                <View key={t} style={styles.legendItem}>
                  <View style={[styles.legendDot, {backgroundColor: EVENT_COLORS[t]}]} />
                  <Text style={styles.legendText}>{t}</Text>
                </View>
              ))}
            </View>
          </View>
          <Text style={styles.description}>
            Live callbacks from{' '}
            <Text style={styles.code}>AppticsPushModuleEmitter</Text>.
          </Text>
          {events.length === 0 ? (
            <View style={styles.emptyLog}>
              <Text style={styles.emptyLogText}>
                No events yet. Send a push from the Apptics console to see
                callbacks here.
              </Text>
            </View>
          ) : (
            <View style={styles.logBox}>
              {events.map((e, i) => (
                <View key={i} style={styles.logRow}>
                  <View
                    style={[
                      styles.logDot,
                      {backgroundColor: EVENT_COLORS[e.type]},
                    ]}
                  />
                  <View style={styles.logContent}>
                    <Text style={styles.logType}>{e.type}</Text>
                    <Text style={styles.logSummary} numberOfLines={2}>
                      {e.summary}
                    </Text>
                  </View>
                  <Text style={styles.logTime}>{e.time}</Text>
                </View>
              ))}
            </View>
          )}
        </View>

        {/* API reference */}
        <View style={styles.card}>
          <Text style={styles.sectionTitle}>API Reference</Text>
          {[
            {
              call: 'AppticsPushMessages.startService()',
              note: 'Called once in App.tsx on init',
            },
            {
              call: 'AppticsPushMessages.registerPushNotification()',
              note: 'iOS only - Triggers OS permission + token registration',
            },
            {
              call: 'AppticsPushMessages.setForegroundNotificationOptions()',
              note: 'iOS only — controls foreground display',
            },
            {
              call: 'AppticsPushModuleEmitter.onMessageReceived',
              note: 'Fires when a push payload is received',
            },
            {
              call: 'AppticsPushModuleEmitter.onNotificationClick',
              note: 'Fires when the user taps a notification',
            },
            {
              call: 'AppticsPushModuleEmitter.onNotificationActionClick',
              note: 'Fires when the user taps an action button',
            },
          ].map(item => (
            <View key={item.call} style={styles.apiRow}>
              <Text style={styles.apiCall}>{item.call}</Text>
              <Text style={styles.apiNote}>{item.note}</Text>
            </View>
          ))}
        </View>

      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
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
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 6,
  },
  sectionTitle: {fontSize: 15, fontWeight: '700', color: '#1A1A2E'},
  badge: {
    backgroundColor: '#D1FAE5',
    borderRadius: 20,
    paddingHorizontal: 10,
    paddingVertical: 3,
  },
  badgeText: {color: '#065F46', fontSize: 12, fontWeight: '600'},
  description: {fontSize: 13, color: '#6B7280', marginBottom: 12, lineHeight: 18},
  code: {fontFamily: 'monospace', color: '#4A90E2'},
  btn: {
    backgroundColor: '#4A90E2',
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
  },
  btnDisabled: {backgroundColor: '#D1FAE5'},
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
  // Foreground options grid
  optionGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  optionBtn: {
    flex: 1,
    minWidth: '45%',
    borderWidth: 1.5,
    borderColor: '#E5E7EB',
    borderRadius: 10,
    padding: 12,
    alignItems: 'center',
  },
  optionBtnActive: {
    borderColor: '#4A90E2',
    backgroundColor: '#EFF6FF',
  },
  optionLabel: {fontSize: 14, fontWeight: '600', color: '#6B7280'},
  optionLabelActive: {color: '#1E40AF'},
  optionDesc: {fontSize: 11, color: '#9CA3AF', marginTop: 2},
  optionDescActive: {color: '#3B82F6'},
  // Event log
  legendRow: {flexDirection: 'row', gap: 10},
  legendItem: {flexDirection: 'row', alignItems: 'center', gap: 4},
  legendDot: {width: 7, height: 7, borderRadius: 4},
  legendText: {fontSize: 11, color: '#6B7280'},
  emptyLog: {
    backgroundColor: '#F9FAFB',
    borderRadius: 8,
    padding: 16,
    alignItems: 'center',
  },
  emptyLogText: {fontSize: 13, color: '#9CA3AF', textAlign: 'center', lineHeight: 18},
  logBox: {
    backgroundColor: '#1A1A2E',
    borderRadius: 10,
    padding: 12,
  },
  logRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 10,
  },
  logDot: {width: 8, height: 8, borderRadius: 4, marginTop: 3, marginRight: 8, flexShrink: 0},
  logContent: {flex: 1, marginRight: 6},
  logType: {fontSize: 11, fontWeight: '700', color: '#E5E7EB', textTransform: 'uppercase'},
  logSummary: {fontSize: 11, color: '#9CA3AF', fontFamily: 'monospace', marginTop: 1},
  logTime: {fontSize: 10, color: '#4B5563'},
  // API reference
  apiRow: {
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#F3F4F6',
  },
  apiCall: {
    fontSize: 12,
    fontFamily: 'monospace',
    color: '#4A90E2',
    marginBottom: 2,
  },
  apiNote: {fontSize: 12, color: '#6B7280'},
});
