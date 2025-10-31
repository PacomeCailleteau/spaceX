import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingTab extends StatelessWidget {
  const OnboardingTab({
    super.key,
    this.image,
    required this.title,
    required this.description,
  });

  final String? image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            if (image != null)
              ClipOval(
                child: Image.asset(
                  image!,
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 48),
            Text(
              title,
              style: GoogleFonts.exo2(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
