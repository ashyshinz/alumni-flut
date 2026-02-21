import 'package:flutter/material.dart';

// --- Page Imports ---
// Ensure these files exist in your lib/ folder
import 'login_page.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';
import 'employment_page.dart';
import 'career_timeline_page.dart';
import 'documents_page.dart';
import 'verification_page.dart';
import 'announcements_page.dart';
import 'settings_page.dart';
import 'surveys_page.dart'; // Tracer Studies module

// --- Shell Imports ---
import 'admin_main.dart';
import 'dean_main.dart';

void main() => runApp(const AlumniPortalApp());

class AlumniPortalApp extends StatelessWidget {
  const AlumniPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alumni Portal',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const MainShell(),
        '/admin_dashboard': (context) => const AdminMainShell(),
        '/dean_dashboard': (context) => const DeanMainShell(),
      },
    );
  }
}

// Logic to determine if user goes to Login or Dashboard
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final bool _isLoggedIn = false; 

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const MainShell() : const LoginPage();
  }
}

// --- ALUMNI MAIN SHELL ---
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Mock notifications for the top header
  final List<Map<String, String>> _notifications = [
    {"title": "Profile Verified", "msg": "Your profile is now 100% verified.", "time": "2m ago"},
    {"title": "Tracer Study", "msg": "New survey: Graduate Success 2026.", "time": "1h ago"},
    {"title": "Document Update", "msg": "Your Diploma copy was approved.", "time": "5h ago"},
  ];

  // List of Page Widgets
 final List<Widget> _pages = [
  const DashboardPage(),        // Index 0
  const ProfilePage(),          // Index 1
  const EmploymentPage(),       // Index 2
  const CareerTimelinePage(),   // Index 3
  const DocumentsPage(),        // Index 4
  const VerificationPage(),     // Index 5
  const SurveysPage(),          // Index 6 (The new addition)
  const AnnouncementsPage(),    // Index 7
  const SettingsPage(),          // Index 8
];

  // --- AI ASSISTANT MODAL ---
  void _showAIChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFF8E2DE2), size: 28),
                  const SizedBox(width: 12),
                  const Text("AI Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text("Hello AJ! How can I help you navigate the portal today?", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(color: Colors.grey)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Ask me anything...",
                  suffixIcon: const Icon(Icons.send, color: Color(0xFF420031)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AI FLOATING BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: _showAIChat,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 32),
        ),
      ),

      body: Row(
        children: [
          // 1. SIDEBAR
          Container(
            width: 260,
            decoration: const BoxDecoration(color: Color(0xFF420031)),
            child: Column(
              children: [
                _buildSidebarHeader(),
                const Divider(color: Colors.white12, indent: 20, endIndent: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _navItem(Icons.grid_view_rounded, "Dashboard", 0),
                      _navItem(Icons.person_outline, "Profile", 1),
                      _navItem(Icons.work_outline, "Employment", 2),
                      _navItem(Icons.trending_up, "Career Timeline", 3),
                      _navItem(Icons.description_outlined, "Documents", 4),
                      _navItem(Icons.verified_user_outlined, "Verification", 5),
                      _navItem(Icons.assignment_outlined, "Surveys & Tracer", 6),
                      _navItem(Icons.campaign_outlined, "Announcements", 7),
                      _navItem(Icons.settings_outlined, "Settings", 8),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                _navItem(Icons.logout, "Logout", -1),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSidebarHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.school, color: Color(0xFF420031), size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Alumni Portal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Class of 2020", style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                  hintText: "Search alumni, jobs, or announcements...",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const Spacer(),

          // Notification Bell
          PopupMenuButton<int>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF420031), size: 28),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFB58D3D), shape: BoxShape.circle),
                    child: Text("${_notifications.length}", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(enabled: false, child: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold))),
              const PopupMenuDivider(),
              ..._notifications.map((n) => PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(n['msg']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Divider(),
                  ],
                ),
              )),
            ],
          ),

          const SizedBox(width: 25),

          // User Profile
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("AJ Domopoy", style: TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("Alumni User", style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF420031),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFC69C6D) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        onTap: () {
          if (index == -1) {
            _showLogoutDialog();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Do you want to leave the Alumni Portal?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}