import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

// --- 1. Login Header (Logo + Text) ---
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Image.asset('assets/images/app_icon.png', height: 100),
        const SizedBox(height: 20),
        const Text(
          "غسل سيارتك\nفي اي وقت و اي مكان",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

// --- 2. Tab Switcher (Phone vs Email) ---
class LoginTabSwitcher extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const LoginTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTab(0, "رقم الهاتف", Icons.phone_iphone),
          _buildTab(1, "البريد الإلكتروني", Icons.email_outlined),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCE4EC) : Colors.transparent,
            borderRadius: index == 0
                ? const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))
                : const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            border: isSelected
                ? Border.all(color: const Color(0xFF8E24AA), width: 0.5)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isSelected ? const Color(0xFF8E24AA) : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF8E24AA) : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 3. Custom Text Field (Matching Login Design) ---
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool isPhone;

  const LoginTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.isPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8E24AA)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: isPhone
            ? CountryCodePicker(
          initialSelection: 'SA',
          favorite: const ['+966', '+971', 'EG'],
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          builder: (country) => Container(
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(country!.flagUri!, package: 'country_code_picker', width: 25),
                const SizedBox(width: 6),
                Text(
                  country.dialCode ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Cairo'),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
              ],
            ),
          ),
        )
            : suffixIcon,
      ),
    );
  }
}

// --- 4. Footer (Create Account) ---
class LoginFooter extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const LoginFooter({super.key, required this.onRegisterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("ليس لديك حساب؟", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        TextButton(
          onPressed: onRegisterTap,
          child: const Text("انشاء حساب", style: TextStyle(color: Color(0xFF7B3F7E), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}