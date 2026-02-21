import 'package:flutter/material.dart';

class VerificationQueuePage extends StatefulWidget {
  const VerificationQueuePage({super.key});

  @override
  State<VerificationQueuePage> createState() => _VerificationQueuePageState();
}

class _VerificationQueuePageState extends State<VerificationQueuePage> {
  // 1. DATA SOURCE: List of pending requests to manage state
  final List<Map<String, dynamic>> _requests = [
    {
      "name": "Sarah Johnson",
      "id": "ALM-2024-001",
      "priority": "high priority",
      "details": "Computer Science • Batch 2024 • Submitted 2024-11-19",
    },
    {
      "name": "Michael Chen",
      "id": "ALM-2024-002",
      "priority": "high priority",
      "details": "Computer Science • Batch 2024 • Submitted 2024-11-19",
    },
  ];

  // 2. ACTION: Process Approval/Rejection
  void _processVerification(int index, bool isApproved) {
    String name = _requests[index]['name'];
    setState(() {
      _requests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApproved ? "Approved $name" : "Rejected $name"),
        backgroundColor: isApproved ? const Color(0xFF28A745) : const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 3. ACTION: Simulate Viewing Documents
  void _showDocumentPreview(String docType, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$docType - $name"),
        content: Container(
          height: 300,
          width: 400,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text("Document Preview Placeholder"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Verification Queue", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Review and approve pending alumni verification requests", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 25),

          // DYNAMIC STATS CARDS
          Row(
            children: [
              _topStatCard("Pending Requests", _requests.length.toString(), Icons.access_time),
              _topStatCard("High Priority", _requests.length.toString(), Icons.assignment_outlined),
              _topStatCard("Avg. Processing Time", "2.5 days", Icons.access_time),
            ],
          ),
          const SizedBox(height: 30),

          // DYNAMIC LIST
          if (_requests.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("No pending requests", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final user = _requests[index];
                return _verificationRequestCard(index, user['name'], user['id'], user['priority'], user['details']);
              },
            ),
        ],
      ),
    );
  }

  Widget _topStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Icon(icon, size: 18, color: Colors.black87),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _verificationRequestCard(int index, String name, String id, String priority, String details) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Color(0xFFC62828)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(id, style: const TextStyle(color: Colors.black54)),
                    Text(details, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              _statusBadge(priority, const Color(0xFFFFDADA), const Color(0xFFC62828)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Submitted Documents:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            children: [
              _docChip("Documents", () => _showDocumentPreview("Official Diploma", name)),
              const SizedBox(width: 10),
              _docChip("ID", () => _showDocumentPreview("Government ID", name)),
              const SizedBox(width: 10),
              _docChip("Employment Proof", () => _showDocumentPreview("Employment Proof", name)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _processVerification(index, true),
                  child: const Text("Approve Verification", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _processVerification(index, false),
                  child: const Text("Reject Verification", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _docChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, size: 16),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 5),
            const Icon(Icons.visibility_outlined, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}