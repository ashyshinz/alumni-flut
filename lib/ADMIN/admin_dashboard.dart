import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. STATS ROW
          Row(
            children: [
              _statCard("1,248", "Total Verified Alumni", Icons.person_outline),
              _statCard("34", "Pending Verification", Icons.people_outline),
              _statCard("89", "Unverified Alumni", Icons.person_add_disabled_outlined),
              _statCard("87.3%", "Employment Rate", Icons.work_outline),
            ],
          ),
          const SizedBox(height: 25),

          // 2. CHARTS ROW
          Row(
            children: [
              _chartBox("Employment Rate Trend", "Last 6 months", _buildLineChart(), 2),
              _chartBox("Batch Employment Status", "By graduation year", _buildBarChart(), 1),
            ],
          ),
          const SizedBox(height: 25),

          // 3. SUBMISSIONS & QUICK ACTIONS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _recentSubmissions(),
              const SizedBox(width: 15),
              _quickActions(),
            ],
          ),
        ],
      ),
    );
  }

  // --- CHART BUILDERS ---

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.black12, strokeWidth: 1),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.black12, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: true, topTitles: AxisTitles(), rightTitles: AxisTitles()),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black12)),
        lineBarsData: [
          // Cyan Line
          LineChartBarData(
            spots: const [FlSpot(0, 40), FlSpot(1, 75), FlSpot(2, 85), FlSpot(3, 20), FlSpot(5, 45), FlSpot(6, 80), FlSpot(9, 20)],
            isCurved: false,
            color: Colors.cyanAccent,
            barWidth: 2,
            dotData: const FlDotData(show: true),
          ),
          // Pink Line
          LineChartBarData(
            spots: const [FlSpot(0, 20), FlSpot(1, 50), FlSpot(2, 25), FlSpot(3, 75), FlSpot(4, 70), FlSpot(5, 30), FlSpot(8, 70), FlSpot(9, 60)],
            isCurved: false,
            color: Colors.pinkAccent,
            barWidth: 2,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: true, topTitles: AxisTitles(), rightTitles: AxisTitles()),
        barGroups: [
          _makeGroupData(0, 60, 25),
          _makeGroupData(1, 45, 85),
          _makeGroupData(2, 25, 15),
          _makeGroupData(3, 10, 65),
          _makeGroupData(4, 50, 80),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: Colors.greenAccent, width: 15, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: Colors.blueAccent, width: 15, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _chartBox(String title, String subtitle, Widget chart, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 350,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 20),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  Widget _recentSubmissions() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Alumni Submissions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.black, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 10),
            _submissionItem("Sarah Johnson"),
            _submissionItem("Sarah Johnson"),
            _submissionItem("Sarah Johnson"),
            _submissionItem("Sarah Johnson"),
            _submissionItem("Sarah Johnson"),
          ],
        ),
      ),
    );
  }

  Widget _submissionItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFFD68B8B)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: const Text("Computer Science • Batch 2024", style: TextStyle(fontSize: 11)),
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("pending", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
            Text("5 mins ago", style: TextStyle(color: Colors.black54, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black87, size: 28),
            const SizedBox(height: 20),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          _actionBtn("Verify Alumni", const Color(0xFF1A1AFF)),
          _actionBtn("Verify Reports", const Color(0xFFFF4500)),
          _actionBtn("Manage Announcements", const Color(0xFF32CD32)),
          _actionBtn("Chat Support", const Color(0xFFD000FF)),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const Padding(padding: EdgeInsets.only(right: 10), child: Icon(Icons.arrow_forward, size: 18)),
          ],
        ),
      ),
    );
  }
}