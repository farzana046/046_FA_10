import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchMedicines() async {
    final response = await supabase.from('medicines').select();
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> addMedicine(String name, String dosage, String time) async {
    final String userId = supabase.auth.currentUser!.id;

    await supabase.from('medicines').insert({
      'name': name,
      'dosage': dosage,
      'time': time,
      'user_id': userId,
    });
  }

  Future<void> updateMedicine(
    int id,
    String name,
    String dosage,
    String time,
  ) async {
    await supabase
        .from('medicines')
        .update({'name': name, 'dosage': dosage, 'time': time})
        .eq('id', id);
  }

  Future<void> deleteMedicine(int id) async {
    await supabase.from('medicines').delete().eq('id', id);
  }
}
