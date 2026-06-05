import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthImagePanel extends StatelessWidget {
  const AuthImagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image — faint
        Image.asset(
          'assets/image/auth.jpg',
          fit: BoxFit.cover,
        ),

        // Dark overlay — heavy enough to wash out the image
        Container(color: const Color(0xFF1a1a2e).withValues(alpha: 0.85)),

        // Content
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo — swap SvgPicture for your actual logo asset
              SvgPicture.asset(
                'assets/svgs/logo-white.svg',
                height: 32,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),

              // Middle content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7c6ef0).withValues(alpha: 0.18),
                      border: Border.all(
                        color: const Color(0xFF7c6ef0).withValues(alpha: 0.35),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFa89cf5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Geo-Temporal Attendance System',
                          style: TextStyle(fontSize: 12, color: Color(0xFFa89cf5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Attendance,\naccounted for.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Location-verified, QR-secured attendance\nfor Nigerian universities.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),

              // Stats row
              IntrinsicHeight(
                child: Row(
                  children: [
                    _Stat(value: '4 layers', label: 'of verification'),
                    const VerticalDivider(color: Colors.white10, width: 40),
                    _Stat(value: 'Real-time', label: 'confidence scoring'),
                    const VerticalDivider(color: Colors.white10, width: 40),
                    _Stat(value: 'Tamper-proof', label: 'records'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}