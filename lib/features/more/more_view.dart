import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/more/more_controller.dart';
import 'package:listing_app/widgets/app_bar/app_header.dart';

class MoreView extends StatelessWidget {
  final MoreController c = Get.isRegistered<MoreController>()
      ? Get.find<MoreController>()
      : Get.put(MoreController());

  MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
          () => Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 🌙 Theme Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  c.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                  color: theme.colorScheme.primary,
                ),
                title: Text("theme".tr, style: theme.textTheme.bodyLarge),
                trailing: Switch(
                  value: c.isDarkMode.value,
                  onChanged: (_) => c.toggleTheme(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 🌍 Language Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.language, color: theme.colorScheme.primary),
                title: Text("language".tr, style: theme.textTheme.bodyLarge),
                trailing: DropdownButton<String>(
                  value: c.currentLang.value,
                  underline: const SizedBox(), // remove underline
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (val) {
                    if (val != null) c.changeLanguage(val);
                  },
                  items: const [
                    DropdownMenuItem(value: "en", child: Text("English")),
                    DropdownMenuItem(value: "ar", child: Text("العربية")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
