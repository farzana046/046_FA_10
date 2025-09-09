import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch all medicines
  Future<List<Map<String, dynamic>>> fetchMedicines() async {
    final response = await supabase.from('medicines').select();
    return List<Map<String, dynamic>>.from(response as List);
  }

  // Add new medicine
  Future<void> addMedicine(String name) async {
    if (name.isEmpty) return;
    await supabase.from('medicines').insert({'name': name});
  }

  // Update medicine
  Future<void> updateMedicine(int id, String name) async {
    await supabase.from('medicines').update({'name': name}).eq('id', id);
  }

  // Delete medicine
  Future<void> deleteMedicine(int id) async {
    await supabase.from('medicines').delete().eq('id', id);
  }
}
