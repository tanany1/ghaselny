import 'package:flutter/material.dart';
import 'package:ghaselny/features/home/data/subscription_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Data for the 3 Subscription Cards
  final List<Map<String, dynamic>> _subscriptionPlans = [
    {
      'title': 'خفيفة',
      'washCount': 3,
      'description': 'للي يحبون سياراتهم دايم نظيفة،\n بس ما يحتاجون غسيل كثير',
      'price': '99',
      'imagePath': 'assets/images/pattern_light.png', // Add your specific image here
    },
    {
      'title': 'متوسطة',
      'washCount': 5,
      'description': 'أنسب باقة للي يحب يحافظ على نظافة\n سيارته طول الشهر بدون قلق',
      'price': '139',
      'imagePath': 'assets/images/pattern_medium.png', // Different image
    },
    {
      'title': 'فخمة',
      'washCount': 10,
      'description': 'للي يحب سيارته تبقى لامعة على\n طول الشهر، من غير ما يفكر مرتين',
      'price': '299',
      'imagePath': 'assets/images/pattern_premium.png', // Different image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We extend body behind AppBar to achieve the gradient look if we used a real AppBar.
      // Here we build a custom header instead.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeaderAndSlider(),
            SizedBox(height: 20,),
            Text(
              'اختر الخدمة اللي تناسبك',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title is white in the design against purple
              ),
            ),
            // To handle the white section curving up, we put the rest in a container
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildServiceOptionCard(
                    title: 'غسيل فوري',
                    subtitle: 'نرسل لك أقرب عامل فورًا',
                    icon: Icons.directions_car_filled_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildServiceOptionCard(
                    title: 'احجز موعد',
                    subtitle: 'اختر الموعد الأنسب لغسيل سيارتك',
                    icon: Icons.calendar_month_outlined,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget for the top gradient section containing address and slider
  Widget _buildTopHeaderAndSlider() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF9E76A0), // Lighter purple top
            Color(0xFF835386), // Darker purple bottom
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Address Dropdown
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'الرياض، حي الملقا ...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                  // The "7403" Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '7403, أور ...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // The Slider (Horizontal ListView)
            SizedBox(
              height: 240, // Fixed height for the slider area
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _subscriptionPlans.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final plan = _subscriptionPlans[index];
                  return SubscriptionCard(
                    title: plan['title'],
                    washCount: plan['washCount'],
                    description: plan['description'],
                    price: plan['price'],
                    imagePath: plan['imagePath'], // Pass the path here
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // The Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFD7A3C6), // Pinkish selected color
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: _selectedIndex == 0 ? const Color(0xFFF3DDF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Icon(Icons.home_filled)),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'طلباتي',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }


  // Reusable Widget for the bottom two service options
  Widget _buildServiceOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.grey.shade700),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}