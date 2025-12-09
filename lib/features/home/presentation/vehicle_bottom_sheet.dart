import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghaselny/features/home/bloc/vehicle_bloc.dart';
import 'package:ghaselny/features/home/data/vehicle_model.dart';
import 'package:ghaselny/features/home/data/vehicle_repo.dart';

class VehicleBottomSheet extends StatefulWidget {
  const VehicleBottomSheet({super.key});

  @override
  State<VehicleBottomSheet> createState() => _VehicleBottomSheetState();
}

class _VehicleBottomSheetState extends State<VehicleBottomSheet> {
  bool showAddForm = false;

  @override
  Widget build(BuildContext context) {
    // Provide Bloc here so the sheet has access to it
    return BlocProvider(
      create: (context) => VehicleBloc(VehicleRepository())..add(LoadVehicles()),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6, // 85% height
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: showAddForm ? _buildAddFormView() : _buildListView(),
      ),
    );
  }

  // --- View 1: List of Vehicles ---
  Widget _buildListView() {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VehicleError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is VehicleLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'اختر مركبتك المفضلة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const Text(
                'سنستخدم السيارة التي تختارها في الطلبات القادمة',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 20),

              // List
              Expanded(
                child: ListView.separated(
                  itemCount: state.vehicles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final v = state.vehicles[index];
                    final isSelected = v == state.selectedVehicle;
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isSelected ? Colors.purple : Colors.grey.shade300,
                            width: isSelected ? 2 : 1
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${v.manufacturer} ${v.model}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${v.plateNumber.numbers} | ${v.plateNumber.letters}", style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Icon(
                            v.type == 'car' ? Icons.directions_car : Icons.two_wheeler,
                            color: isSelected ? Colors.purple : Colors.grey,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() { showAddForm = true; });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("إضافة مركبة جديدة", style: TextStyle(fontFamily: 'Cairo')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              )
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  // --- View 2: Add New Vehicle Form ---
  Widget _buildAddFormView() {
    // Controllers for the form
    final TextEditingController makeCtrl = TextEditingController();
    final TextEditingController modelCtrl = TextEditingController();
    final TextEditingController lettersCtrl = TextEditingController();
    final TextEditingController numbersCtrl = TextEditingController();
    String selectedType = 'car';

    return StatefulBuilder( // Use StatefulBuilder to update local form state (like radio buttons)
        builder: (context, setStateForm) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() { showAddForm = false; }),
                  ),
                  const Text("إضافة مركبة جديدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                ],
              ),
              const SizedBox(height: 20),

              // Type Toggle
              const Text("معلومات مركبتك", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTypeSelector("سيارة", Icons.directions_car, selectedType == 'car', () {
                    setStateForm(() => selectedType = 'car');
                  }),
                  const SizedBox(width: 15),
                  _buildTypeSelector("دراسة", Icons.two_wheeler, selectedType == 'motorcycle', () {
                    setStateForm(() => selectedType = 'motorcycle');
                  }),
                ],
              ),
              const SizedBox(height: 15),

              // Text Fields
              _buildTextField("مصنع المركبة (الماركة)", makeCtrl),
              const SizedBox(height: 10),
              _buildTextField("طراز المركبة (الموديل)", modelCtrl),
              const SizedBox(height: 15),

              const Text("رقم اللوحة", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildTextField("أحرف", lettersCtrl)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField("أرقام", numbersCtrl, isNumber: true)),
                ],
              ),

              const Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF835386),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // Create Object
                    final newVehicle = Vehicle(
                        manufacturer: makeCtrl.text,
                        model: modelCtrl.text,
                        type: selectedType,
                        plateNumber: PlateNumber(
                            letters: lettersCtrl.text,
                            numbers: numbersCtrl.text
                        )
                    );

                    // Dispatch Event
                    context.read<VehicleBloc>().add(AddNewVehicle(newVehicle));

                    // Go back to list
                    setState(() { showAddForm = false; });
                  },
                  child: const Text("حفظ المركبة", style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16)),
                ),
              )
            ],
          );
        }
    );
  }

  Widget _buildTypeSelector(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF3DDF1) : Colors.white,
            border: Border.all(color: isSelected ? const Color(0xFF835386) : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF835386) : Colors.grey),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: isSelected ? const Color(0xFF835386) : Colors.grey, fontFamily: 'Cairo')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}