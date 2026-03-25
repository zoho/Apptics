import React, {useEffect, useState} from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Alert,
} from 'react-native';
import {
  Apptics,
  AppticsAppUpdate,
  UpdateStats,
} from '@zoho_apptics/apptics-react-native';

export default function UpdatesScreen() {
  const [updateData, setUpdateData] = useState<Record<string, any> | null>(null);

  useEffect(() => {
    Apptics.screenAttached('UpdatesScreen');
    return () => {
      Apptics.screenDetached('UpdatesScreen');
    };
  }, []);

  const showDefaultPopup = () => {
    AppticsAppUpdate.showVersionAlertPopup();
    Apptics.addEvent('in_app_update_popup_shown', 'Updates', {});
  };

  const checkForUpdate = async () => {
    try {
      const data = await AppticsAppUpdate.checkForUpdate() as Record<string, any> | null;
      if (data) {
        setUpdateData(data);
        Apptics.addEvent('update_available', 'Updates', {
          version: data.currentversion ?? 'unknown',
        });
        Alert.alert('Update Available', `Version: ${data.currentversion ?? 'N/A'}`);
      } else {
        setUpdateData(null);
        Alert.alert('No Update', 'Your app is up to date.');
      }
    } catch (e) {
      Alert.alert('Error', 'Could not check for updates.');
    }
  };

  const sendImpression = () => {
    if (!updateData?.updateid) {
      Alert.alert('No Update', 'Check for update first.');
      return;
    }
    AppticsAppUpdate.sendUpdateStat(updateData.updateid, UpdateStats.Impression);
    Apptics.addEvent('update_impression_sent', 'Updates', {});
    Alert.alert('Done', 'Impression stat sent.');
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.infoBox}>
          <Text style={styles.infoText}>
            Make sure <Text style={styles.code}>Apptics.init()</Text> is called
            before any update APIs. Configure update settings in the Apptics
            console.
          </Text>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Built-in Update Popup</Text>
          <Text style={styles.description}>
            Displays the default Apptics-styled version alert popup.
          </Text>
          <TouchableOpacity style={styles.btn} onPress={showDefaultPopup}>
            <Text style={styles.btnText}>Show Version Alert Popup</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Custom Update Flow</Text>
          <Text style={styles.description}>
            Fetch update data and build your own UI.
          </Text>
          <TouchableOpacity
            style={[styles.btn, {backgroundColor: '#7B68EE'}]}
            onPress={checkForUpdate}>
            <Text style={styles.btnText}>Check for Update</Text>
          </TouchableOpacity>

          {updateData && (
            <View style={styles.dataBox}>
              <Text style={styles.dataTitle}>Update Data:</Text>
              {Object.entries(updateData).map(([k, v]) => (
                <Text key={k} style={styles.dataRow}>
                  <Text style={styles.dataKey}>{k}:</Text>{' '}
                  {String(v ?? 'null')}
                </Text>
              ))}
              <TouchableOpacity
                style={[styles.btn, {backgroundColor: '#50C878', marginTop: 12}]}
                onPress={sendImpression}>
                <Text style={styles.btnText}>Send Impression Stat</Text>
              </TouchableOpacity>
            </View>
          )}
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Android Theme</Text>
          <Text style={styles.description}>
            Customize update dialog colors in{' '}
            <Text style={styles.code}>main/res/values/styles.xml</Text>:
          </Text>
          {[
            'appticsTextColor',
            'appticsSecondaryTextColor',
            'appticsUpdateActionButtonColor',
            'appticsUpdateActionButtonTextColor',
            'appticsRemindAndIgnoreActionButtonColor',
          ].map(attr => (
            <Text key={attr} style={styles.attrItem}>
              • {attr}
            </Text>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: '#F5F7FA'},
  container: {padding: 20, paddingBottom: 40},
  infoBox: {
    backgroundColor: '#ECFDF5',
    borderRadius: 10,
    padding: 14,
    marginBottom: 16,
  },
  infoText: {fontSize: 13, color: '#065F46', lineHeight: 20},
  code: {fontFamily: 'monospace', backgroundColor: '#D1FAE5', paddingHorizontal: 3},
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
  sectionTitle: {fontSize: 15, fontWeight: '700', color: '#1A1A2E', marginBottom: 6},
  description: {fontSize: 13, color: '#374151', marginBottom: 12},
  btn: {
    backgroundColor: '#50C878',
    borderRadius: 8,
    padding: 14,
    alignItems: 'center',
  },
  btnText: {color: '#FFF', fontWeight: '600', fontSize: 15},
  dataBox: {marginTop: 12, backgroundColor: '#F9FAFB', borderRadius: 8, padding: 12},
  dataTitle: {fontWeight: '700', color: '#1A1A2E', marginBottom: 6, fontSize: 13},
  dataRow: {fontSize: 12, color: '#374151', marginBottom: 3},
  dataKey: {fontWeight: '600'},
  attrItem: {fontSize: 13, color: '#374151', paddingVertical: 2},
});
