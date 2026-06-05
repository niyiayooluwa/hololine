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
        Image.asset('assets/images/javon-swaby.jpg', fit: BoxFit.cover),

        // Dark overlay — heavy enough to wash out the image
        Container(color: const Color(0xFF1a1a2e).withValues(alpha: 0.85)),

        // Content
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/svgs/logos/Osaka-white.svg',
                height: 60,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),

              // Middle content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
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
                          'Built for Distributed Businesses',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFa89cf5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Business,\nin order.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.w500,
                      height: 1.00,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'One platform to manage your inventory,\nsales and team. Built for how distributed\nbusinesses actually work.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                ],
              ),

              // Stats row
              IntrinsicHeight(
                child: Row(
                  children: [
                    _Stat(value: 'Multi-Tenant', label: 'workspace management'),
                    const VerticalDivider(color: Colors.white10, width: 40),
                    _Stat(value: 'Real-time', label: 'inventory tracking'),
                    const VerticalDivider(color: Colors.white10, width: 40),
                    _Stat(value: 'AI-Powered', label: 'reporting'),
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
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
