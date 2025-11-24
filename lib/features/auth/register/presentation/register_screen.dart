import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 0 = Phone, 1 = Email
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allow the body to extend behind the AppBar area if needed
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A3A74), // Darker purple top
              Color(0xFF9E65A5), // Lighter purple
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Image.asset('assets/images/app_icon.png'),
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

            const Spacer(),

            // --- Bottom White Sheet ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Custom Toggle Tabs ---
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        // Phone Tab (Selected in design)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? const Color(0xFFFCE4EC)
                                    : Colors.transparent,
                                // Pinkish bg if selected
                                borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                                border: selectedTab == 0
                                    ? Border.all(
                                        color: const Color(0xFF8E24AA),
                                        width: 0.5,
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_iphone,
                                    size: 20,
                                    color: selectedTab == 0
                                        ? const Color(0xFF8E24AA)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "رقم الهاتف",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedTab == 0
                                          ? const Color(0xFF8E24AA)
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Email Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? const Color(0xFFFCE4EC)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                border: selectedTab == 1
                                    ? Border.all(
                                        color: const Color(0xFF8E24AA),
                                        width: 0.5,
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 20,
                                    color: selectedTab == 1
                                        ? const Color(0xFF8E24AA)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "البريد الإلكتروني",
                                    style: TextStyle(
                                      color: selectedTab == 1
                                          ? const Color(0xFF8E24AA)
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    decoration: InputDecoration(
                      labelText: selectedTab == 0 ? 'رقم الهاتف' : 'البريد الإلكتروني',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF8E24AA)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                      // Using the package here
                      // RTL Logic: SuffixIcon appears on the LEFT
                      suffixIcon: selectedTab == 0
                          ? CountryCodePicker(
                        onChanged: (country) {
                          print("Selected country: ${country.dialCode}");
                        },
                        initialSelection: 'SA',
                        favorite: const ['+966', '+971', 'EG'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,

                        // Custom Builder to change layout: [Flag] [Code] [Arrow]
                        builder: (country) {
                          return Container(
                            // Give it a fixed width to look like a proper dropdown
                            width: 110,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              // Force Left-to-Right direction regardless of Arabic app setting
                              // This ensures Flag is on Left and Arrow is on Right visually.
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 1. Flag
                                Image.asset(
                                  country!.flagUri!,
                                  package: 'country_code_picker',
                                  width: 25,
                                ),

                                // 2. Space
                                const SizedBox(width: 6),

                                // 3. Code
                                Text(
                                  country.dialCode ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Cairo'
                                  ),
                                ),

                                const SizedBox(width: 4),

                                // 4. Arrow
                                const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 18
                                ),
                              ],
                            ),
                          );
                        },

                        // Dialog styling
                        dialogTextStyle: const TextStyle(fontFamily: 'Cairo'),
                        searchDecoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'ابحث عن دولة...',
                          border: OutlineInputBorder(),
                        ),
                      )
                          : null,
                    ),
                    keyboardType: selectedTab == 0 ? TextInputType.phone : TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 100), // Spacing before button
                  // --- Submit Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B3F7E),
                        // Purple button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "ارسل كود التحقق",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
