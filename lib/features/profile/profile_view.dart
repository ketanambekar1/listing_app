import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/profile/profile_controller.dart';
import 'package:listing_app/widgets/app_bar/app_header.dart';

class ProfileView extends StatelessWidget {
  final ProfileController c = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// --- Avatar + Basic Info ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(c.userImage.value),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      c.userName.value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      c.userEmail.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// --- Info Cards ---
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.phone, color: theme.colorScheme.primary),
                  title: Text("phone".tr),
                  subtitle: Text(c.userPhone.value),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.email, color: theme.colorScheme.primary),
                  title: Text("email".tr),
                  subtitle: Text(c.userEmail.value),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.login_outlined, color: theme.colorScheme.primary),
                  title: Text("Logout".tr),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final info = c.appInfoService.info;
                if (info == null) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('- v${info.version}(${info.buildNumber}) -')],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
