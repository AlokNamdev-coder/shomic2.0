import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shomic_2/Screens/SecondaryScreens/bio_screen.dart';

class GenderScreen extends StatefulWidget {
  final String email;
  final String username;
  final String fullname;
  final String phoneNumber;
  final String dateTime;
  const GenderScreen({super.key,required this.email,required this.username,required this.fullname,required this.phoneNumber,required this.dateTime});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  final List<String> genders = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Center(child: Text("Shomic.",style: GoogleFonts.outfit(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 50),)),

              // Progress
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 4,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF8B5CF6),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     Expanded(
              //       child: Container(
              //         height: 4,
              //         decoration: BoxDecoration(
              //           color: Colors.white12,
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     Expanded(
              //       child: Container(
              //         height: 4,
              //         decoration: BoxDecoration(
              //           color: Colors.white12,
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 20),

              // Heading
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Choose the option that best describes you.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 38),

              // Options
              ...genders.map(
                    (gender) {
                  final bool isSelected = selectedGender == gender;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = gender;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF8B5CF6).withOpacity(0.12)
                            : const Color(0xFF121218),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : Colors.white10,
                          width: isSelected ? 1.2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              gender,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedGender == null
                      ? null
                      : () {
                    debugPrint(
                      'Selected gender: $selectedGender',
                    );
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BioScreen(email:widget.email, username:widget.username, phoneNumber:widget.phoneNumber, fullname:widget.fullname, dateTime:widget.dateTime,gender:selectedGender!,)));

                    // Navigate to next screen
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF8B5CF6),
                    disabledBackgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}