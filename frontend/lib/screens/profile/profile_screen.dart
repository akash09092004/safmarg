import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/route_names.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  Future<void> _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Kya aap SafMarg se logout karna chahte hain?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (result != true || !mounted) {
      return;
    }

    await context.read<AuthProvider>().logout();

    if (mounted) {
      context.read<ProfileProvider>().reset();
    }

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    final user = provider.user;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            onPressed: user == null
                ? null
                : () async {
                    await Navigator.pushNamed(context, RouteNames.editProfile);

                    if (context.mounted) {
                      context.read<ProfileProvider>().loadProfile();
                    }
                  },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),

      body: provider.isLoading && user == null
          ? const LoadingWidget(message: 'Loading profile...')
          : user == null
          ? _errorView(provider.errorMessage)
          : RefreshIndicator(
              onRefresh: () => provider.loadProfile(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 35),
                children: [
                  _profileHeader(user.name, user.email),

                  const SizedBox(height: 20),

                  _section(
                    title: 'My Account',
                    children: [
                      _menu(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.editProfile);
                        },
                      ),
                      _menu(
                        icon: Icons.flight_outlined,
                        title: 'My Bookings',
                        subtitle: 'View your flight bookings',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.myBookings);
                        },
                      ),
                      _menu(
                        icon: Icons.currency_exchange,
                        title: 'My Refunds',
                        subtitle: 'View refund requests and status',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.refund);
                        },
                      ),
                      _menu(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'View your notifications',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.profileNotifications,
                          );
                        },
                        last: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _section(
                    title: 'Support & Legal',
                    children: [
                      _menu(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get help with SafMarg',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.helpSupport);
                        },
                      ),
                      _menu(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.privacyPolicy,
                          );
                        },
                      ),
                      _menu(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.terms);
                        },
                        last: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: .25),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: AppColors.error),
                          SizedBox(width: 13),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      'SafMarg v1.0.0',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _profileHeader(String name, String email) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0866e5), Color(0xff4a9bf5)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 7),
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _menu({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool last = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle == null
              ? null
              : Text(subtitle, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15),
          onTap: onTap,
        ),
        if (!last) const Divider(height: 1, indent: 68),
      ],
    );
  }

  Widget _errorView(String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 15),
            Text(
              message ?? 'Profile load nahi hui.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileProvider>().loadProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
