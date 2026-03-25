import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  Switch,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  ActivityIndicator,
} from 'react-native';
import {Apptics, TrackingState} from '@zoho_apptics/apptics-react-native';

/**
 * Maps the three user-facing toggles to an Apptics TrackingState enum value.
 *
 * Engagements  = Usage (Events, Screens, Sessions, APIs)
 * Crash        = Crash & Non-fatal exceptions
 * PII          = Whether user data set via Apptics.setUser() is included
 */
function resolveTrackingState(
  engagements: boolean,
  crash: boolean,
  pii: boolean,
): TrackingState {
  if (engagements && crash) {
    return pii
      ? TrackingState.UsageAndCrashTrackingWithPII
      : TrackingState.UsageAndCrashTrackingWithoutPII;
  }
  if (engagements) {
    return pii
      ? TrackingState.OnlyUsageTrackingWithPII
      : TrackingState.OnlyUsageTrackingWithoutPII;
  }
  if (crash) {
    return pii
      ? TrackingState.OnlyCrashTrackingWithPII
      : TrackingState.OnlyCrashTrackingWithoutPII;
  }
  return TrackingState.NoTracking;
}

/** Derives the three toggle states from a TrackingState enum value. */
function parseTrackingState(state: TrackingState): {
  engagements: boolean;
  crash: boolean;
  pii: boolean;
} {
  switch (state) {
    case TrackingState.UsageAndCrashTrackingWithPII:
      return {engagements: true, crash: true, pii: true};
    case TrackingState.UsageAndCrashTrackingWithoutPII:
      return {engagements: true, crash: true, pii: false};
    case TrackingState.OnlyUsageTrackingWithPII:
      return {engagements: true, crash: false, pii: true};
    case TrackingState.OnlyUsageTrackingWithoutPII:
      return {engagements: true, crash: false, pii: false};
    case TrackingState.OnlyCrashTrackingWithPII:
      return {engagements: false, crash: true, pii: true};
    case TrackingState.OnlyCrashTrackingWithoutPII:
      return {engagements: false, crash: true, pii: false};
    default:
      return {engagements: false, crash: false, pii: false};
  }
}

const TOGGLE_ITEMS = [
  {
    key: 'engagements' as const,
    label: 'Track Engagements',
    description: 'Events, screens, sessions, and API usage',
    color: '#4A90E2',
  },
  {
    key: 'crash' as const,
    label: 'Track Crash & Non-fatal',
    description: 'Unhandled exceptions and non-fatal errors',
    color: '#E25C5C',
  },
  {
    key: 'pii' as const,
    label: 'Track with PII',
    description:
      'Include personally identifiable info set via Apptics.setUser()',
    color: '#FF8C00',
  },
];

const STATE_LABELS: Record<TrackingState, string> = {
  [TrackingState.UsageAndCrashTrackingWithPII]: 'Usage + Crash + PII',
  [TrackingState.UsageAndCrashTrackingWithoutPII]: 'Usage + Crash (no PII)',
  [TrackingState.OnlyUsageTrackingWithPII]: 'Usage only + PII',
  [TrackingState.OnlyUsageTrackingWithoutPII]: 'Usage only (no PII)',
  [TrackingState.OnlyCrashTrackingWithPII]: 'Crash only + PII',
  [TrackingState.OnlyCrashTrackingWithoutPII]: 'Crash only (no PII)',
  [TrackingState.NoTracking]: 'No Tracking',
};

export default function PrivacyScreen() {
  const [loading, setLoading] = useState(true);
  const [engagements, setEngagements] = useState(true);
  const [crash, setCrash] = useState(true);
  const [pii, setPii] = useState(false);

  useEffect(() => {
    Apptics.screenAttached('PrivacyScreen');
    // Load the current tracking state from the SDK on mount
    Apptics.getTrackingState().then(state => {
      const parsed = parseTrackingState(state);
      setEngagements(parsed.engagements);
      setCrash(parsed.crash);
      setPii(parsed.pii);
      setLoading(false);
    });
    return () => {
      Apptics.screenDetached('PrivacyScreen');
    };
  }, []);

  const handleToggle = (
    key: 'engagements' | 'crash' | 'pii',
    value: boolean,
  ) => {
    const next = {
      engagements: key === 'engagements' ? value : engagements,
      crash: key === 'crash' ? value : crash,
      pii: key === 'pii' ? value : pii,
    };
    if (key === 'engagements') {setEngagements(value);}
    if (key === 'crash') {setCrash(value);}
    if (key === 'pii') {setPii(value);}

    const newState = resolveTrackingState(next.engagements, next.crash, next.pii);
    Apptics.setTrackingState(newState);
    Apptics.addEvent('tracking_state_changed', 'Privacy', {
      state: String(newState),
    });
  };

  const activeState = resolveTrackingState(engagements, crash, pii);
  const values = {engagements, crash, pii};

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            Control what data Apptics collects. Changes take effect immediately
            via{' '}
            <Text style={styles.code}>Apptics.setTrackingState()</Text>.
          </Text>
        </View>

        {loading ? (
          <ActivityIndicator size="large" color="#4A90E2" style={styles.loader} />
        ) : (
          <>
            {TOGGLE_ITEMS.map(item => (
              <View key={item.key} style={styles.card}>
                <View style={styles.cardLeft}>
                  <View style={[styles.dot, {backgroundColor: item.color}]} />
                  <View style={styles.cardText}>
                    <Text style={styles.cardTitle}>{item.label}</Text>
                    <Text style={styles.cardDesc}>{item.description}</Text>
                  </View>
                </View>
                <Switch
                  value={values[item.key]}
                  onValueChange={v => handleToggle(item.key, v)}
                  trackColor={{false: '#E5E7EB', true: item.color + '66'}}
                  thumbColor={values[item.key] ? item.color : '#9CA3AF'}
                />
              </View>
            ))}

            <View style={styles.stateBox}>
              <Text style={styles.stateLabel}>Active Tracking State</Text>
              <Text style={styles.stateValue}>{STATE_LABELS[activeState]}</Text>
              <Text style={styles.stateEnum}>
                TrackingState.{TrackingState[activeState]}
              </Text>
            </View>

            <View style={styles.matrixBox}>
              <Text style={styles.matrixTitle}>State Reference</Text>
              {Object.entries(STATE_LABELS).map(([k, label]) => (
                <View
                  key={k}
                  style={[
                    styles.matrixRow,
                    Number(k) === activeState && styles.matrixRowActive,
                  ]}>
                  <Text
                    style={[
                      styles.matrixText,
                      Number(k) === activeState && styles.matrixTextActive,
                    ]}>
                    {label}
                  </Text>
                  {Number(k) === activeState && (
                    <Text style={styles.matrixCheck}>✓</Text>
                  )}
                </View>
              ))}
            </View>
          </>
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
  code: {
    fontFamily: 'monospace',
    backgroundColor: '#DBEAFE',
    paddingHorizontal: 3,
  },
  loader: {marginTop: 40},
  card: {
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 2,
  },
  cardLeft: {flexDirection: 'row', alignItems: 'center', flex: 1, marginRight: 12},
  dot: {width: 10, height: 10, borderRadius: 5, marginRight: 12, flexShrink: 0},
  cardText: {flex: 1},
  cardTitle: {fontSize: 15, fontWeight: '600', color: '#1A1A2E'},
  cardDesc: {fontSize: 12, color: '#6B7280', marginTop: 2},
  stateBox: {
    backgroundColor: '#1A1A2E',
    borderRadius: 12,
    padding: 16,
    marginTop: 8,
    marginBottom: 16,
    alignItems: 'center',
  },
  stateLabel: {color: '#9CA3AF', fontSize: 12, fontWeight: '600', marginBottom: 6},
  stateValue: {color: '#FFFFFF', fontSize: 16, fontWeight: '700', marginBottom: 4},
  stateEnum: {color: '#6B7280', fontSize: 11, fontFamily: 'monospace'},
  matrixBox: {
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.06,
    shadowRadius: 8,
    elevation: 2,
  },
  matrixTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: '#6B7280',
    marginBottom: 10,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  matrixRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 7,
    paddingHorizontal: 10,
    borderRadius: 8,
    marginBottom: 2,
  },
  matrixRowActive: {backgroundColor: '#EFF6FF'},
  matrixText: {flex: 1, fontSize: 13, color: '#6B7280'},
  matrixTextActive: {color: '#1E40AF', fontWeight: '600'},
  matrixCheck: {color: '#4A90E2', fontWeight: '700', fontSize: 14},
});
