import 'package:flutter/material.dart';
import '../services/medicine_service.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final medicineService = MedicineService();
  final _medicineController = TextEditingController();
  List medicines = [];

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  void loadMedicines() async {
    final meds = await medicineService.fetchMedicines();
    setState(() {
      medicines = meds;
    });
  }

  void addMedicine() async {
    await medicineService.addMedicine(_medicineController.text);
    _medicineController.clear();
    loadMedicines();
  }

  void updateMedicine(int id, String newName) async {
    await medicineService.updateMedicine(id, newName);
    loadMedicines();
  }

  void deleteMedicine(int id) async {
    await medicineService.deleteMedicine(id);
    loadMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Medicines"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medicineController,
                    decoration: const InputDecoration(
                      hintText: "Enter medicine name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addMedicine,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];
                final TextEditingController editController =
                    TextEditingController(text: med['name']);
                return ListTile(
                  title: Text(med['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Edit Medicine"),
                              content: TextField(controller: editController),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    updateMedicine(
                                      med['id'],
                                      editController.text,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteMedicine(med['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
