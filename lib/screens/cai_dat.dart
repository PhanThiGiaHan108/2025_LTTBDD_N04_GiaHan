import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dang_nhap.dart';
import 've_chung_toi.dart';

class SettingsTab extends StatelessWidget {
  final bool isDarkMode;
  final double fontSize;
  final Color themeColor;
  final Function(bool) onDarkModeChanged;
  final Function(double) onFontSizeChanged;
  final Function(Color) onThemeColorChanged;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const SettingsTab({
    super.key,
    required this.isDarkMode,
    required this.fontSize,
    required this.themeColor,
    required this.onDarkModeChanged,
    required this.onFontSizeChanged,
    required this.onThemeColorChanged,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Text(
            'settings'.tr(),
            style: TextStyle(
              fontSize: 24 * fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Language
        _buildSettingsCard(
          cardColor: cardColor,
          textColor: textColor,
          themeColor: themeColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.language, color: themeColor),
                  const SizedBox(width: 10),
                  Text(
                    "language".tr(),
                    style: TextStyle(
                      fontSize: 18 * fontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: themeColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<Locale>(
                  value: currentLocale,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: cardColor,
                  style: TextStyle(color: textColor, fontSize: 16 * fontSize),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) onLocaleChanged(newLocale);
                  },
                  items: [
                    DropdownMenuItem(
                      value: const Locale('vi'),
                      child: Text(
                        '🇻🇳 Tiếng Việt',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text(
                        '🇬🇧 English',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Appearance
        _buildSettingsCard(
          cardColor: cardColor,
          textColor: textColor,
          themeColor: themeColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.palette, color: themeColor),
                  const SizedBox(width: 10),
                  Text(
                    "appearance".tr(),
                    style: TextStyle(
                      fontSize: 18 * fontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Dark Mode
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "dark_mode".tr(),
                  style: TextStyle(color: textColor, fontSize: 16 * fontSize),
                ),
                subtitle: Text(
                  "dark_mode_desc".tr(),
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 14 * fontSize,
                  ),
                ),
                value: isDarkMode,
                activeColor: themeColor,
                onChanged: onDarkModeChanged,
              ),
              const Divider(),
              // Font Size
              Text(
                "font_size".tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 16 * fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Slider(
                value: fontSize,
                min: 0.8,
                max: 1.2,
                divisions: 4,
                label: fontSize.toStringAsFixed(2),
                onChanged: onFontSizeChanged,
              ),
              const Divider(),
              // Theme Color
              Text(
                "theme_color".tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 16 * fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildColorButton(
                    Colors.deepPurple,
                    themeColor,
                    onThemeColorChanged,
                  ),
                  _buildColorButton(
                    Colors.blue,
                    themeColor,
                    onThemeColorChanged,
                  ),
                  _buildColorButton(
                    Colors.green,
                    themeColor,
                    onThemeColorChanged,
                  ),
                  _buildColorButton(
                    Colors.orange,
                    themeColor,
                    onThemeColorChanged,
                  ),
                  _buildColorButton(
                    Colors.pink,
                    themeColor,
                    onThemeColorChanged,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Other Actions
        _buildSettingsCard(
          cardColor: cardColor,
          textColor: textColor,
          themeColor: themeColor,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline, color: themeColor),
                title: Text(
                  "about".tr(),
                  style: TextStyle(color: textColor, fontSize: 16 * fontSize),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: textColor,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VeChungToi()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  "logout".tr(),
                  style: TextStyle(color: Colors.red, fontSize: 16 * fontSize),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: textColor,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DangNhap()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSettingsCard({
    required Color cardColor,
    required Color textColor,
    required Color themeColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildColorButton(
    Color color,
    Color selectedColor,
    Function(Color) onTap,
  ) {
    final isSelected = color.value == selectedColor.value;
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }
}
