import 'package:flutter/material.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- DATA SOURCES ---
  final List<Map<String, dynamic>> _announcements = [
    {
      "type": "Event",
      "title": "Alumni Reunion 2025",
      "desc": "Join us for our biggest reunion yet! June 15-17, 2025.",
      "author": "Admin",
      "date": "2024-11-15",
      "eventDate": "June 15, 2025",
      "views": "1234",
    },
    {
      "type": "Announcement",
      "title": "New Career Services",
      "desc": "Free career counseling services are now available.",
      "author": "Admin",
      "date": "2024-11-10",
      "eventDate": "",
      "views": "892",
    },
  ];

  final List<Map<String, dynamic>> _surveys = [
    {
      "title": "Graduate Tracer Study 2026",
      "desc": "Official tracking for accreditation.",
      "responses": "450",
      "status": "Active",
      "date": "2024-12-01"
    },
    {
      "title": "Employer Satisfaction Survey",
      "desc": "Feedback from partner companies.",
      "responses": "128",
      "status": "Draft",
      "date": "2024-12-05"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- THEME HELPER ---
  Map<String, Color> _getTheme(String type) {
    if (type == "Event" || type == "Active") {
      return {
        "bg": const Color(0xFFFFEAEA),
        "icon": const Color(0xFFFF4D4D),
      };
    }
    return {
      "bg": const Color(0xFFF3E5F5),
      "icon": const Color(0xFF6C5DD3),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 25),
            
            // STATS ROW
            Row(
              children: [
                _statBox("Total Posts", _announcements.length.toString()),
                _statBox("Active Surveys", _surveys.where((s) => s['status'] == "Active").length.toString()),
                _statBox("Engagement", "2.1k"),
              ],
            ),
            
            const SizedBox(height: 25),
            
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF420031),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFD4A017),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: "Announcements & Events"),
                Tab(text: "Tracer Studies & Surveys"),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAnnouncementsList(),
                  _buildSurveysList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Communication Hub", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF420031))),
            Text("Manage university announcements and tracer study data", 
              style: TextStyle(color: Colors.black54)),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4A017),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => _showEntryDialog(),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Create New", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _statBox(String title, String count) {
    return Expanded(
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          ],
        ),
      ),
    );
  }

  // --- LIST BUILDERS ---

  Widget _buildAnnouncementsList() {
    return ListView.builder(
      itemCount: _announcements.length,
      itemBuilder: (context, index) {
        final item = _announcements[index];
        final theme = _getTheme(item['type']);
        return _buildActionCard(
          title: item['title'],
          subtitle: item['desc'],
          meta: "By ${item['author']} • ${item['date']}",
          icon: item['type'] == "Event" ? Icons.event : Icons.campaign,
          theme: theme,
          onDelete: () => setState(() => _announcements.removeAt(index)),
        );
      },
    );
  }

  Widget _buildSurveysList() {
    return ListView.builder(
      itemCount: _surveys.length,
      itemBuilder: (context, index) {
        final survey = _surveys[index];
        final theme = _getTheme(survey['status']);
        return _buildActionCard(
          title: survey['title'],
          subtitle: "${survey['responses']} Responses Collected",
          meta: "Created: ${survey['date']} • Status: ${survey['status']}",
          icon: Icons.poll_rounded,
          theme: theme,
          onDelete: () => setState(() => _surveys.removeAt(index)),
        );
      },
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String meta,
    required IconData icon,
    required Map<String, Color> theme,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme['bg'], borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: theme['icon']),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(meta, style: const TextStyle(color: Colors.black26, fontSize: 11)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent), onPressed: onDelete),
        ],
      ),
    );
  }

  // --- DIALOGS ---

  void _showEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Content"),
        content: const Text("Would you like to publish a new Announcement or start a new Tracer Study Survey?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Announcement")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017)),
            child: const Text("Survey", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}