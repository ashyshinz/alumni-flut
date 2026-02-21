import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole;
  final List<String> roles = ["Alumni", "Admin", "Dean"];

  // Function to open the browser for social logins
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF420031),
      body: Stack(
        children: [
          // 1. BACKGROUND GOLD SHAPE
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              color: const Color(0xFFB58D3D),
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          ),

          // 2. LOGO
          Positioned(
            left: 60,
            top: 40,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Image.asset(
                'assets/logo.png',
                height: 150,
                width: 150,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
          ),

          // 3. TEXT SECTION
          Positioned(
            left: 60,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 180),
                _buildLargeText("HELLO"),
                _buildLargeText("WELCOME,"),
                _buildLargeText(
                  selectedRole?.toUpperCase() ?? "USER",
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // 4. LOGIN BOX SECTION
          Align(
            alignment: const Alignment(0.85, 0.0),
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: const Color(0xFFB58D3D),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundColor: Color(0xFFE8F0FE),
                        child: Icon(Icons.person, size: 100, color: Color(0xFF4285F4)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Role ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        const SizedBox(height: 8),
                        _buildDropdown(),
                        const SizedBox(height: 25),
                        _buildField(Icons.account_circle_outlined, "Username"),
                        const SizedBox(height: 15),
                        _buildField(Icons.email_outlined, "Email"),
                        const SizedBox(height: 15),
                        _buildField(Icons.lock_outline, "Password", isPass: true),
                        const SizedBox(height: 15),
                        const Text("Forgot Password?", style: TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedRole != null) {
                                final route = selectedRole == "Dean" 
                                  ? '/dean_dashboard' 
                                  : (selectedRole == "Admin" ? '/admin_dashboard' : '/dashboard');
                                Navigator.pushReplacementNamed(context, route);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select a Role first")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF420031),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // UPDATED SOCIAL LOGIN SECTION
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC69C6D),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        const Text("Or Login With", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        InkWell(
                          onTap: () => _launchURL('https://www.linkedin.com/login'),
                          child: _socialIcon(FontAwesomeIcons.linkedin, "LinkedIn"),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () => _launchURL('https://accounts.google.com/'),
                          child: _socialIcon(FontAwesomeIcons.google, "Google"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildLargeText(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 160,
        fontWeight: FontWeight.w900,
        color: color,
        height: 0.82,
        letterSpacing: -6,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          hint: const Text("Select Role"),
          items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
          onChanged: (v) => setState(() => selectedRole = v),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String hint, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        obscureText: isPass,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[700], size: 24),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: Colors.white, size: 20), // Use FaIcon for FontAwesome
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width * 0.6, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}