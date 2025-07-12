import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futuropdv/auth/login_page.dart';
import 'package:futuropdv/backend/repositories/user_repository.dart';
import 'package:futuropdv/pages/home_page.dart';
import 'package:futuropdv/pages/onboarding_widget.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, check user roles
          return FutureBuilder<DocumentSnapshot?>(
            future: _userRepository.getUserById(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (userSnapshot.hasData && userSnapshot.data != null) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final userRoles = userData?['userRoles'] as List?;
                final onboardingCompleted = userData?['onboardingCompleted'] as bool? ?? false;

                if (userRoles == null || userRoles.isEmpty || !onboardingCompleted) {
                  // If user has no roles or hasn't completed onboarding, they need to go through onboarding/selection
                  return const OnboardingWidget(); // This will lead to selection screen
                } else {
                  // User has roles and completed onboarding, go to home page
                  return const HomePage();
                }
              }
              // If user data is not found (should not happen for a logged in user), go to login
              return const LoginPage();
            },
          );
        }
        // User is not logged in
        return const LoginPage();
      },
    );
  }
} 