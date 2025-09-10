import 'package:flutter/material.dart';
import '../services/medicine_service.dart';
import '../auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MedicineService medicineService = MedicineService();
  List<Map<String, dynamic>> medicines = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    final data = await medicineService.fetchMedicines();
    setState(() {
      medicines = data;
    });
  }

  void clearControllers() {
    _nameController.clear();
    _dosageController.clear();
    _timeController.clear();
  }

  Future<void> addMedicine() async {
    final name = _nameController.text.trim();
    final dosage = _dosageController.text.trim();
    final time = _timeController.text.trim();

    if (name.isEmpty || dosage.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    await medicineService.addMedicine(name, dosage, time);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine added successfully')),
    );
    clearControllers();
    fetchMedicines();
  }

  Future<void> updateMedicine(int id) async {
    final name = _nameController.text.trim();
    final dosage = _dosageController.text.trim();
    final time = _timeController.text.trim();

    if (name.isEmpty || dosage.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    await medicineService.updateMedicine(id, name, dosage, time);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine updated successfully')),
    );
    clearControllers();
    fetchMedicines();
  }

  Future<void> deleteMedicine(int id) async {
    await medicineService.deleteMedicine(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine deleted successfully')),
    );
    fetchMedicines();
  }

  void showMedicineDialog({Map<String, dynamic>? medicine}) {
    if (medicine != null) {
      _nameController.text = medicine['name'];
      _dosageController.text = medicine['dosage'];
      _timeController.text = medicine['time'];
    } else {
      clearControllers();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(medicine == null ? 'Add Medicine' : 'Update Medicine'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'Select time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    _timeController.text = pickedTime.format(context);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearControllers();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (medicine == null) {
                await addMedicine();
              } else {
                await updateMedicine(medicine['id']);
              }
              Navigator.pop(context);
            },
            child: Text(medicine == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userEmail = AuthService().getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(title: const Text('MediMind')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'User Profile',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail ?? 'Not Signed In',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFE1F5FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  medicine['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Dosage: ${medicine['dosage']}, Time: ${medicine['time']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => showMedicineDialog(medicine: medicine),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteMedicine(medicine['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => showMedicineDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
