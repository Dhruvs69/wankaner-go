import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';

class SettingsBottomSheet extends ConsumerWidget {
  const SettingsBottomSheet({super.key});

  void _showProfileDialog(BuildContext context, WidgetRef ref) {
    final userAsync = ref.read(currentUserStreamProvider);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: userAsync.when(
          data: (user) {
            if (user == null) return const Text('No user data found.');
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange.shade100,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.role.toUpperCase(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(user.phone),
                  contentPadding: EdgeInsets.zero,
                ),
                if (user.email != null && user.email!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(user.email!),
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            );
          },
          loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
          error: (e, st) => Text('Error: $e'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.headset_mic, color: Colors.blue),
            SizedBox(width: 8),
            Text('Help & Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with your order or account? Reach out to us directly!'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email, color: Colors.deepOrange),
              title: Text('support@wankanergo.com'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text('+91 98765 43210'),
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 8),
            Text('Our support team is available from 9 AM to 10 PM daily.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy & Policy'),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "Wankaner Go Privacy Policy\\n\\n"
              "1. Information Collection: We collect your name, phone number, email, and location data to provide delivery services.\\n\\n"
              "2. Data Usage: Your data is used exclusively to process orders, facilitate vendor communications, and ensure delivery partner accuracy.\\n\\n"
              "3. Data Sharing: We do not sell your personal data. We share necessary details (like your delivery address) only with assigned delivery partners.\\n\\n"
              "4. Security: We employ industry-standard security measures to protect your account and transactions.\\n\\n"
              "By using Wankaner Go, you consent to this policy.",
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('I Understand')),
        ],
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Wankaner Go',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.storefront, color: Colors.white, size: 40),
      ),
      applicationLegalese: '© 2026 Wankaner Go. All rights reserved.\nDelivering happiness across Wankaner.',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'App Settings & Facilities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepOrange),
            title: const Text('My Profile'),
            subtitle: const Text('View and edit personal details'),
            onTap: () {
              Navigator.pop(context);
              _showProfileDialog(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help with orders or issues'),
            onTap: () {
              Navigator.pop(context);
              _showHelpSupportDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.green),
            title: const Text('Privacy & Policy'),
            onTap: () {
              Navigator.pop(context);
              _showPrivacyPolicyDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('About Wankaner Go'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              Navigator.pop(context);
              _showAboutAppDialog(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SettingsBottomSheet(),
  );
}
