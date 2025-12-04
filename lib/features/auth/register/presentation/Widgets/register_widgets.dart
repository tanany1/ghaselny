import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

// --- Shared Helper for Text Fields ---
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.textAlign = TextAlign.right,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: textAlign,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8E24AA)),
        ),
      ),
    );
  }
}

// --- Step 1: Personal Info Widget ---
class RegisterPersonalInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onNext;

  const RegisterPersonalInfoStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("إنشاء حساب جديد (1 من 2)", textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("معلوماتك الشخصية", textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          CustomTextField(
            controller: nameController,
            hintText: 'اسمك بالكامل',
            validator: (val) => (val?.isEmpty ?? true) ? 'الاسم مطلوب' : null,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\u0600-\u06FF\s]'))],
          ),
          const SizedBox(height: 15),

          CustomTextField(
            controller: emailController,
            hintText: 'البريد الإلكتروني',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) return 'البريد الإلكتروني مطلوب';
              if (!val.contains('@')) return 'بريد إلكتروني غير صحيح';
              return null;
            },
          ),
          const SizedBox(height: 15),

          CustomTextField(
            controller: phoneController,
            hintText: '',
            labelText: 'رقم الهاتف',
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.left, // Phone usually LTR
            validator: (val) => (val?.isEmpty ?? true) ? 'رقم الهاتف مطلوب' : null,
            suffixIcon: CountryCodePicker(
              onChanged: (c) => print("Country: ${c.dialCode}"),
              initialSelection: 'SA',
              favorite: const ['+966', '+971', 'EG'],
              showCountryOnly: false,
              builder: (country) => SizedBox(
                width: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(country!.flagUri!, package: 'country_code_picker', width: 25),
                    const SizedBox(width: 6),
                    Text(country.dialCode ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          CustomTextField(
            controller: passwordController,
            hintText: 'كلمة المرور',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (val) => (val != null && val.length < 6) ? 'كلمة المرور قصيرة' : null,
          ),
          const SizedBox(height: 15),

          CustomTextField(
            controller: confirmPasswordController,
            hintText: 'تأكيد كلمة المرور',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (val) => val != passwordController.text ? 'غير متطابقة' : null,
          ),
          const SizedBox(height: 40),

          SizedBox(
            height: 55,
            child: OutlinedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onNext();
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7B3F7E)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("التالي", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF7B3F7E))),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step 2: Vehicle Info Widget ---
class RegisterVehicleInfoStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController plateLettersController;
  final TextEditingController plateNumbersController;
  final Function(bool isCar) onVehicleTypeChanged;
  final VoidCallback onSubmit;

  const RegisterVehicleInfoStep({
    super.key,
    required this.formKey,
    required this.makeController,
    required this.modelController,
    required this.plateLettersController,
    required this.plateNumbersController,
    required this.onVehicleTypeChanged,
    required this.onSubmit,
  });

  @override
  State<RegisterVehicleInfoStep> createState() => _RegisterVehicleInfoStepState();
}

class _RegisterVehicleInfoStepState extends State<RegisterVehicleInfoStep> {
  bool isCarSelected = true;

  Widget _buildToggle(String label, IconData icon, bool isCar) {
    bool isSelected = (isCarSelected == isCar);
    return GestureDetector(
      onTap: () {
        setState(() => isCarSelected = isCar);
        widget.onVehicleTypeChanged(isCar);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF7B3F7E) : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? const Color(0xFF7B3F7E) : Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF7B3F7E) : Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("إنشاء حساب جديد (2 من 2)", textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("معلومات مركبتك", textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          CustomTextField(
            controller: widget.makeController,
            hintText: 'مصنع المركبة (الماركة)',
            validator: (v) => (v?.isEmpty ?? true) ? 'مطلوب' : null,
          ),
          const SizedBox(height: 15),

          CustomTextField(
            controller: widget.modelController,
            hintText: 'طراز المركبة (الموديل)',
            validator: (v) => (v?.isEmpty ?? true) ? 'مطلوب' : null,
          ),
          const SizedBox(height: 20),

          const Text("رقم اللوحة", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            children: [
              _buildToggle("سيارة", Icons.directions_car, true),
              const SizedBox(width: 12),
              _buildToggle("دراجة", Icons.two_wheeler, false),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: widget.plateLettersController,
                  hintText: 'احرف',
                  textAlign: TextAlign.center,
                  validator: (v) => (v?.isEmpty ?? true) ? 'مطلوب' : null,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\u0600-\u06FF\s]'))],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  controller: widget.plateNumbersController,
                  hintText: 'ارقام',
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v?.isEmpty ?? true) ? 'مطلوب' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  widget.onSubmit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B3F7E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("انشاء الحساب", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}