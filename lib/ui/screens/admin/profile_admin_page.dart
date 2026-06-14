import 'package:flutter/material.dart';
import '../../widgets/custom_profile_screen.dart';

class ProfileAdminPage extends StatelessWidget {
  const ProfileAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomProfileScreen(role: 'admin');
  }
}