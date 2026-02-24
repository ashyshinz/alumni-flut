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
    const Color themeColor = Color(0xFF420031);

    return Scaffold(
      backgroundColor: themeColor,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE AREA
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/jmc.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),
          ),

          // 2. LOGO SECTION - REMOVED WHITE BG AND SHADOW
          Positioned(
            left: 60,
            top: 40,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.transparent, // Makes background clear
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo.png', // Ensure this is a transparent PNG
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
                _buildLargeText("HELLO", color: themeColor),
                _buildLargeText("WELCOME,", color: themeColor),
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
                color: Colors.white,
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
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor, width: 4), 
                      ),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 100, color: Color(0xFF4285F4)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Role ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 8),
                        _buildDropdown(themeColor),
                        const SizedBox(height: 25),
                        _buildField(Icons.account_circle_outlined, "Username", themeColor),
                        const SizedBox(height: 15),
                        _buildField(Icons.email_outlined, "Email", themeColor),
                        const SizedBox(height: 15),
                        _buildField(Icons.lock_outline, "Password", themeColor, isPass: true),
                        const SizedBox(height: 15),
                        const Text("Forgot Password?", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
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
                              backgroundColor: themeColor,
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
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        const Text("Or Login With", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        InkWell(
                          onTap: () => _launchURL('https://www.linkedin.com/login'),
                          child: _socialIcon(FontAwesomeIcons.linkedin, "LinkedIn", themeColor),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () => _launchURL('https://accounts.google.com/'),
                          child: _socialIcon(FontAwesomeIcons.google, "Google", themeColor),
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

  Widget _buildDropdown(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: themeColor, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          iconEnabledColor: themeColor,
          hint: const Text("Select Role", style: TextStyle(color: Colors.black)),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(color: Colors.black)))).toList(),
          onChanged: (v) => setState(() => selectedRole = v),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String hint, Color themeColor, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: themeColor, width: 1.5),
      ),
      child: TextField(
        obscureText: isPass,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: themeColor, size: 24),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label, Color themeColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: themeColor, size: 20),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
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