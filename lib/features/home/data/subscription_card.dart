import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final int washCount;
  final String description;
  final String price;
  final String imagePath; // ADDED: Variable for the specific image

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.washCount,
    required this.description,
    required this.price,
    required this.imagePath, // ADDED
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 211,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Optional: Add a subtle shadow to pop like the design
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // --- PATTERN IMAGE (Bottom Left) ---
          Positioned(
            bottom: 40,
            left: 0,
            // We use a container with ClipRRect to ensure image doesn't bleed outside the rounded corners
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                width: 150, // Adjust size as needed
                height: 150,
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // In RTL, Start is Right
              children: [
                // TOP ROW: Title (Right) and Tag (Left)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 2. Title (Right side in RTL)
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF653662), // Dark purple title
                      ),
                    ),

                    // 1. Wash Count Tag (Left side in RTL)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$washCount غسلات',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // DESCRIPTION (Right Aligned)
                SizedBox(
                  width: 200, // Limit width so text doesn't cover the image too much
                  child: Text(
                    description,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        height: 1.5
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8,), // Pushes content apart

                // PRICE ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Right aligned in RTL
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // Price Number
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Currency Image/Icon
                    Image.asset("assets/images/currency_riyal.png"), // Replace with your currency image
                    const SizedBox(width: 8),
                    // "/ Monthly" text
                    Text(
                        '/ شهرياً',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14)
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SUBSCRIBE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A5A8D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded pill shape
                      ),
                    ),
                    child: const Text(
                      'اشترك الان',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}