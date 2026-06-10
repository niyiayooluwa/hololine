import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EmptyWatchlistCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;

  const EmptyWatchlistCard({
    super.key,
    this.title = 'Your watchlist is empty',
    this.description = 'Start building your crypto watchlist by clicking the button below',
    this.buttonText = 'New asset',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360, // Slimmer width for the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)), // Very subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Illustration Area
          const Padding(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12),
            child: _IllustrationGraphic(),
          ),
          
          const SizedBox(height: 16),
          
          // Text Content Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _ContentSection(
              title: title,
              description: description,
              buttonText: buttonText,
              onPressed: onPressed,
            ),
          ),
          
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _IllustrationGraphic extends StatelessWidget {
  const _IllustrationGraphic();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 210, // Doesn't go all the way to the bottom of the stack
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A), // Slate 900
                    Color(0xFF334155), // Slate 700
                  ],
                ),
              ),
            ),
          ),
          
          // The white "Mockup UI" card that sits on top of the gradient
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            top: 40, // Pushed down slightly from the top of the gradient
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000), // Extremely subtle drop shadow
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: _MockupList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockupList extends StatelessWidget {
  const _MockupList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Header Row of the Mockup
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
          ),
          child: Row(
            children: [
              _buildDot(size: 8),
              const SizedBox(width: 12),
              _buildLine(width: 60, height: 6),
              const Spacer(),
              _buildLine(width: 30, height: 6),
            ],
          ),
        ),
        
        // Mockup List Item 1
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFE2E8F0), size: 20),
              const SizedBox(width: 8),
              _buildCircle(size: 20),
              const SizedBox(width: 8),
              _buildLine(width: 50, height: 6),
              const SizedBox(width: 6),
              _buildLine(width: 16, height: 6),
              const Spacer(),
              const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFE2E8F0), size: 16),
              _buildLine(width: 24, height: 6),
            ],
          ),
        ),
        
        // Mockup List Item 2
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFE2E8F0), size: 20),
              const SizedBox(width: 8),
              _buildCircle(size: 20),
              const SizedBox(width: 8),
              _buildLine(width: 60, height: 6),
              const SizedBox(width: 6),
              _buildLine(width: 20, height: 6),
              const Spacer(),
              const Icon(Icons.arrow_drop_up_rounded, color: Color(0xFFE2E8F0), size: 16),
              _buildLine(width: 24, height: 6),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widgets to draw the skeleton loading shapes
  Widget _buildLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate 100
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  Widget _buildCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
    );
  }
  
  Widget _buildDot({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE2E8F0), // Slightly darker grey for the header dot
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;

  const _ContentSection({
    required this.title,
    required this.description,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A), // Slate 900
            letterSpacing: -0.3,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B), // Slate 500
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Shadcn CTA Button
        ShadButton(
          onPressed: onPressed ?? () {},
          leading: const Padding(
            padding: EdgeInsets.only(right: 6.0),
            child: Icon(Icons.add, size: 16),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}