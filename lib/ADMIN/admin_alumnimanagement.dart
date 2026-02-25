import 'package:flutter/material.dart';

class AlumniManagementPage extends StatefulWidget {
  const AlumniManagementPage({super.key});

  @override
  State<AlumniManagementPage> createState() => _AlumniManagementPageState();
}

class _AlumniManagementPageState extends State<AlumniManagementPage> {
  // 1. DATA SOURCE (The "Database")
  final List<Map<String, dynamic>> _allAlumni = [
    {
      "id": "ALM-2024-001",
      "name": "Sarah Johnson",
      "batch": "2024",
      "program": "Information Technology",
      "employment": "employed",
      "status": "verified",
      "company": "Tech Corp",
      "email": "sarah.j@example.com",
      "phone": "+63 912 345 6789",
      "address": "Davao City, Philippines",
      "docs": ["Diploma.pdf", "TOR.pdf", "Valid_ID.jpg"]
    },
    {
      "id": "ALM-2024-002",
      "name": "Michael Chen",
      "batch": "2023",
      "program": "Computer Science",
      "employment": "employed",
      "status": "verified",
      "company": "DataFlow Inc",
      "email": "m.chen@example.com",
      "phone": "+63 912 987 6543",
      "address": "Tagum City, Philippines",
      "docs": ["Diploma.pdf", "Employment_Cert.pdf"]
    },
    {
      "id": "ALM-2024-003",
      "name": "Emily Rodriguez",
      "batch": "2024",
      "program": "Information Systems",
      "employment": "unemployed",
      "status": "pending",
      "company": "N/A",
      "email": "emily.rod@example.com",
      "phone": "+63 945 111 2222",
      "address": "Panabo City, Philippines",
      "docs": ["Pending_Review.pdf"]
    },
    // Add more here to match your image...
  ];

  // 2. FILTERING LOGIC
  List<Map<String, dynamic>> _foundAlumni = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _foundAlumni = _allAlumni;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allAlumni;
    } else {
      results = _allAlumni
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["id"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundAlumni = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alumni Management",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Text(
            "Manage and verify alumni records",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 25),

          // SEARCH BAR
          _buildSearchBar(),
          const SizedBox(height: 20),

          // TABLE
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 310),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                        columns: const [
                          DataColumn(label: Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Batch', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Program', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Employment', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _foundAlumni.map((alumni) => _buildDataRow(alumni)).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              hintText: "Search by name or ID number...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        _iconButton(Icons.filter_list, "Filter"),
        const SizedBox(width: 10),
        _iconButton(Icons.download, "Export"),
      ],
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> alumni) {
    return DataRow(cells: [
      DataCell(Text(alumni['id'])),
      DataCell(Text(alumni['name'])),
      DataCell(Text(alumni['batch'])),
      DataCell(Text(alumni['program'])),
      DataCell(_statusBadge(alumni['employment'], alumni['employment'] == "employed" ? Colors.blue[50]! : Colors.grey[200]!, alumni['employment'] == "employed" ? Colors.blue : Colors.black54)),
      DataCell(_statusBadge(alumni['status'], alumni['status'] == "verified" ? Colors.green[50]! : Colors.orange[50]!, alumni['status'] == "verified" ? Colors.green : Colors.orange)),
      DataCell(
        IconButton(
          icon: const Icon(Icons.visibility_outlined, color: Color(0xFF420031)),
          onPressed: () => _showAlumniDetails(alumni),
        ),
      ),
    ]);
  }

  // 3. ACTION: SHOW DETAILS DIALOG
  void _showAlumniDetails(Map<String, dynamic> alumni) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Alumni Information"),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
          ],
        ),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailHeader(alumni['name'], alumni['id']),
                const Divider(height: 30),
                _infoSection("Personal Details", {
                  "Email": alumni['email'],
                  "Phone": alumni['phone'],
                  "Address": alumni['address'],
                  "Program": alumni['program'],
                  "Batch": alumni['batch'],
                }),
                const SizedBox(height: 20),
                _infoSection("Employment", {
                  "Status": alumni['employment'].toUpperCase(),
                  "Company": alumni['company'],
                }),
                const SizedBox(height: 20),
                const Text("Uploaded Documents", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: (alumni['docs'] as List).map((doc) => Chip(
                    label: Text(doc),
                    avatar: const Icon(Icons.description, size: 16),
                    backgroundColor: Colors.grey[100],
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF420031)),
            onPressed: () {}, 
            child: const Text("Approve Verification", style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }

  // UI HELPERS
  Widget _detailHeader(String name, String id) {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundColor: const Color(0xFF420031), child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 24))),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(id, style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _infoSection(String title, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF420031))),
        const SizedBox(height: 10),
        ...data.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(width: 80, child: Text("${e.key}:", style: const TextStyle(fontWeight: FontWeight.w600))),
              Text(e.value),
            ],
          ),
        )),
      ],
    );
  }

  Widget _statusBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [Icon(icon, size: 18), const SizedBox(width: 5), Text(label)]),
    );
  }
}