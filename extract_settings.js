const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

// 1. Add import
if (!text.includes('settings_provider.dart')) {
  text = text.replace(/import 'package:flutter\/material\.dart';/, "import 'package:flutter/material.dart';\nimport 'package:wankaner_go/features/auth/providers/settings_provider.dart';");
}

// 2. Replace _buildSettings
text = text.replace(/Widget _buildSettings\(\) \{[\s\S]*?\}\n\s*\}\n/, "Widget _buildSettings() => const _SettingsView();\n");

// 3. Add _SettingsView class
const settingsClass = `
class _SettingsView extends ConsumerStatefulWidget {
  const _SettingsView();

  @override
  ConsumerState<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<_SettingsView> {
  final baseFeeCtrl = TextEditingController();
  final platformCommCtrl = TextEditingController();
  final minOrderCtrl = TextEditingController();
  
  bool maintenanceMode = false;
  bool autoAssignPartners = true;
  bool surgePricing = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    baseFeeCtrl.dispose();
    platformCommCtrl.dispose();
    minOrderCtrl.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    try {
      await ApiService.post('/settings', {
        'baseDeliveryFee': baseFeeCtrl.text,
        'platformCommission': platformCommCtrl.text,
        'minimumOrderValue': minOrderCtrl.text,
        'maintenanceMode': maintenanceMode,
        'autoAssignPartners': autoAssignPartners,
        'surgePricing': surgePricing,
      });
      ref.invalidate(settingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings Saved Successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save settings: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (settings) {
        if (!_isInitialized) {
          baseFeeCtrl.text = settings.baseDeliveryFee;
          platformCommCtrl.text = settings.platformCommission;
          minOrderCtrl.text = settings.minimumOrderValue;
          maintenanceMode = settings.maintenanceMode;
          autoAssignPartners = settings.autoAssignPartners;
          surgePricing = settings.surgePricing;
          _isInitialized = true;
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.local_shipping, color: Colors.deepOrange),
                                  SizedBox(width: 8),
                                  Text('Delivery & Commissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: baseFeeCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Base Delivery Fee (₹)',
                                  prefixIcon: Icon(Icons.currency_rupee),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: platformCommCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Platform Commission (%)',
                                  prefixIcon: Icon(Icons.percent),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: minOrderCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Minimum Order Value (₹)',
                                  prefixIcon: Icon(Icons.shopping_cart_checkout),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                                  SizedBox(width: 8),
                                  Text('System Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SwitchListTile(
                                title: const Text('App Maintenance Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text('Temporarily disable ordering for all customers.'),
                                value: maintenanceMode,
                                activeThumbColor: Colors.red,
                                onChanged: (val) => setState(() => maintenanceMode = val),
                              ),
                              const Divider(),
                              SwitchListTile(
                                title: const Text('Auto-Assign Delivery Partners', style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text('Automatically ping nearby riders when order is ready.'),
                                value: autoAssignPartners,
                                activeThumbColor: Colors.green,
                                onChanged: (val) => setState(() => autoAssignPartners = val),
                              ),
                              const Divider(),
                              SwitchListTile(
                                title: const Text('Surge Pricing (Peak Hours)', style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text('Apply 1.5x delivery fee automatically during high demand.'),
                                value: surgePricing,
                                activeThumbColor: Colors.deepOrange,
                                onChanged: (val) => setState(() => surgePricing = val),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Save All Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: _saveSettings,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
`;

text = text + '\n' + settingsClass;

fs.writeFileSync(file, text);
