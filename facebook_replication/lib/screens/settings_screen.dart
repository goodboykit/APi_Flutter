import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';
import '../constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Settings Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Appearance',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                
                // Dark Mode Toggle
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: FacebookColors.primaryBlue,
                    ),
                    title: const CustomText(
                      text: 'Dark Mode',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: themeProvider.isDarkMode 
                          ? 'Switch to light theme' 
                          : 'Switch to dark theme',
                      fontSize: 14,
                      color: themeProvider.isDarkMode 
                          ? FacebookColors.textSecondaryDark 
                          : FacebookColors.textSecondaryLight,
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: FacebookColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1),
          
          // About Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'About',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                
                // App Version
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: FacebookColors.primaryBlue,
                    ),
                    title: CustomText(
                      text: 'App Version',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: '1.0.0',
                      fontSize: 14,
                      color: themeProvider.isDarkMode 
                          ? FacebookColors.textSecondaryDark 
                          : FacebookColors.textSecondaryLight,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Developer Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.code,
                      color: FacebookColors.primaryBlue,
                    ),
                    title: CustomText(
                      text: 'Developer',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: 'Facebook Replication App',
                      fontSize: 14,
                      color: themeProvider.isDarkMode 
                          ? FacebookColors.textSecondaryDark 
                          : FacebookColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1),
          
          // Additional Settings
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Preferences',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                
                // Notifications (Placeholder)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: FacebookColors.primaryBlue,
                    ),
                    title: const CustomText(
                      text: 'Notifications',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: 'Manage notification preferences',
                      fontSize: 14,
                      color: themeProvider.isDarkMode 
                          ? FacebookColors.textSecondaryDark 
                          : FacebookColors.textSecondaryLight,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle notifications settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notifications settings coming soon!'),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Privacy (Placeholder)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: FacebookColors.primaryBlue,
                    ),
                    title: const CustomText(
                      text: 'Privacy',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: 'Manage privacy settings',
                      fontSize: 14,
                      color: themeProvider.isDarkMode 
                          ? FacebookColors.textSecondaryDark 
                          : FacebookColors.textSecondaryLight,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle privacy settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy settings coming soon!'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}