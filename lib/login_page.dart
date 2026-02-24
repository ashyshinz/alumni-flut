import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedRole;
  final List<String> roles = ["Alumni", "Admin", "Dean"];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String? errorMessage; 
  String? successMessage; 
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    if (selectedRole == null || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => errorMessage = "Please fill in all fields and select a Role");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://localhost/alumni_api/login.php'); 
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text,
          "role": selectedRole!.toLowerCase(),
        }),
      );

      final result = jsonDecode(response.body);

      if (result['status'] == 'success') {
        setState(() => successMessage = "Login Successful! Redirecting...");
        
        String dbRole = result['role'].toString().toLowerCase();
        final route = dbRole == "dean" 
            ? '/dean_dashboard' 
            : (dbRole == "admin" ? '/admin_dashboard' : '/dashboard');
        
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) Navigator.pushReplacementNamed(context, route);
      } else {
        setState(() => errorMessage = result['message']);
      }
    } catch (e) {
      setState(() => errorMessage = "Connection error. Is XAMPP running?");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      setState(() => errorMessage = "Could not launch $url");
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

          // 2. LOGO SECTION
          Positioned(
            left: 60,
            top: 40,
            child: Image.asset(
              'assets/logo.png',
              height: 150,
              width: 150,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
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

          // 4. BIGGER LOGIN BOX SECTION
          Align(
            alignment: const Alignment(0.92, 0.0), // Pushed slightly more to the right
            child: Container(
              width: 600, // INCREASED WIDTH (Bigger box)
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -70),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor, width: 5), 
                      ),
                      child: const CircleAvatar(
                        radius: 90, // Slightly bigger Avatar
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 120, color: Color(0xFF4285F4)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50), // More internal space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (successMessage != null) _buildBanner(successMessage!, Colors.green),
                        if (errorMessage != null) _buildBanner(errorMessage!, Colors.red),

                        const Text("Role", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
                        const SizedBox(height: 12),
                        _buildDropdown(themeColor),
                        const SizedBox(height: 25),
                        _buildField(Icons.email_outlined, "Email Address", themeColor, controller: _emailController),
                        const SizedBox(height: 20),
                        _buildField(Icons.lock_outline, "Password", themeColor, isPass: true, controller: _passwordController),
                        const SizedBox(height: 15),
                        const Text("Forgot Password?", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 35),
                        SizedBox(
                          width: double.infinity,
                          height: 65, // Taller button for the bigger box
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    ),
                    child: Row(
                      children: [
                        const Text("Or login with", style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const Spacer(),
                        _socialButton(FontAwesomeIcons.linkedin, "LinkedIn", themeColor, () => _launchURL('https://linkedin.com')),
                        const SizedBox(width: 20),
                        _socialButton(FontAwesomeIcons.google, "Google", themeColor, () => _launchURL('https://google.com')),
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

  // Helper for Success/Error banners
  Widget _buildBanner(String msg, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(color == Colors.green ? Icons.check_circle : Icons.error, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(msg, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildLargeText(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 120, 
        fontWeight: FontWeight.w900,
        color: color,
        height: 0.82,
        letterSpacing: -6,
      ),
    );
  }

  Widget _buildDropdown(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          iconSize: 30,
          hint: const Text("Choose your role"),
          style: const TextStyle(color: Colors.black, fontSize: 18),
          items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
          onChanged: (v) => setState(() => selectedRole = v),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String hint, Color themeColor, {bool isPass = false, TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(icon, color: themeColor, size: 28),
          ),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 22),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, Color themeColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FaIcon(icon, color: themeColor, size: 22),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
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