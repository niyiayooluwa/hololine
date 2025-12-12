import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hololine_flutter/shared_ui/core/widgets/snackbar/snackbar.dart';
import 'package:hololine_flutter/shared_ui/core/widgets/buttons/buttons.dart';
import 'package:hololine_flutter/shared_ui/core/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ComponentShowcase extends HookConsumerWidget {
  const ComponentShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = useState('Buttons');
    final isDarkMode = useState(false);

    final categories = {
      'Buttons': _buildButtonComponents(),
      'Cards': _buildCardComponents(),
      'Badges': _buildBadgeComponents(),
      'Snackbars': _buildSnackbarComponents(),
      //'Empty States': _buildEmptyStateComponents(),
      'Loading': _buildLoadingComponents(),
    };

    return Theme(
      data: isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: isDarkMode.value
            ? const Color(0xFF0A0E27)
            : const Color.fromARGB(255, 247, 247, 247),
        appBar: AppBar(
          title: const Text('Component Library'),
          backgroundColor:
              isDarkMode.value ? const Color(0xFF0F172A) : Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    size: 20,
                    color: isDarkMode.value
                        ? Colors.grey
                        : const Color(0xFF6366F1),
                  ),
                  Switch(
                    value: isDarkMode.value,
                    onChanged: (value) => isDarkMode.value = value,
                    activeThumbColor: const Color(0xFF8B5CF6),
                  ),
                  Icon(
                    Icons.dark_mode,
                    size: 20,
                    color: isDarkMode.value
                        ? const Color(0xFF8B5CF6)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            // Left sidebar menu
            Container(
              width: 250,
              decoration: BoxDecoration(
                color:
                    isDarkMode.value ? const Color(0xFF0F172A) : Colors.white,
                border: Border(
                  right: BorderSide(
                    color: isDarkMode.value
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: categories.keys.map((category) {
                  final isSelected = selectedCategory.value == category;
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        category,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : isDarkMode.value
                                  ? Colors.white70
                                  : Colors.black87,
                        ),
                      ),
                      onTap: () => selectedCategory.value = category,
                    ),
                  );
                }).toList(),
              ),
            ),
            // Main content area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedCategory.value,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode.value ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: categories[selectedCategory.value]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtonComponents() {
    return [
      _buildComponentCard(
        'Primary Button',
        HoloButton(label: 'Primary Button', onPressed: () {}),
        "HoloButton(\n  label: 'Primary Button',\n  onPressed: () {},\n)",
      ),
      _buildComponentCard(
        'Plain Button',
        HoloButton(
          label: 'Plain Button',
          type: ButtonType.plain,
          onPressed: () {},
        ),
        "HoloButton(\n  label: 'Plain Button',\n  type: ButtonType.plain,\n  onPressed: () {},\n)",
      ),
      _buildComponentCard(
        'Neutral Button',
        HoloButton(
          label: 'Neutral Button',
          type: ButtonType.neutral,
          onPressed: () {},
        ),
        "HoloButton(\n  label: 'Neutral Button',\n  type: ButtonType.neutral,\n  onPressed: () {},\n)",
      ),
      _buildComponentCard(
        'Loading Button',
        HoloButton(label: 'Loading Button', loading: true, onPressed: () {}),
        "HoloButton(\n  label: 'Loading Button',\n  loading: true,\n  onPressed: () {},\n)",
      ),
      _buildComponentCard(
        'Error Button',
        HoloButton(label: 'Error Button', error: true, onPressed: () {}),
        "HoloButton(\n  label: 'Error Button',\n  error: true,\n  onPressed: () {},\n)",
      ),
      _buildComponentCard(
        'Disabled Button',
        const HoloButton(label: 'Disabled Button'),
        "HoloButton(\n  label: 'Disabled Button',\n  // onPressed not provided = disabled\n)",
      ),
    ];
  }

  List<Widget> _buildCardComponents() {
    return [
      _buildComponentCard(
        'Basic Card',
        HLCard(
            child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('This is a card'),
        )),
        "HLCard(\n  child: Text('This is a card'),\n)",
      ),
    ];
  }

  List<Widget> _buildBadgeComponents() {
    return [
      _buildComponentCard(
        'Success Badge',
        StatusBadge.success('Active'),
        "StatusBadge.success('Active')",
      ),
    ];
  }

  List<Widget> _buildSnackbarComponents() {
    return [
      _buildComponentCard(
        'Success Snackbar',
        HoloSnackbar(
          type: ErrorType.success,
          message: 'Success message!',
        ),
        "HoloSnackbar(\n  type: ErrorType.success,\n  message: 'This is a success message!',\n)",
        height: 200,
      ),
      _buildComponentCard(
        'Error Snackbar',
        HoloSnackbar(
          type: ErrorType.error,
          message: 'Error message!',
        ),
        "HoloSnackbar(\n  type: ErrorType.error,\n  message: 'This is an error message!',\n)",
        height: 200,
      ),
      _buildComponentCard(
        'Warning Snackbar',
        HoloSnackbar(
          type: ErrorType.warning,
          message: 'Warning message!',
        ),
        "HoloSnackbar(\n  type: ErrorType.warning,\n  message: 'This is a warning message!',\n)",
        height: 200,
      ),
      _buildComponentCard(
        'Info Snackbar',
        HoloSnackbar(
          type: ErrorType.info,
          message: 'Info message!',
        ),
        "HoloSnackbar(\n  type: ErrorType.info,\n  message: 'This is an info message!',\n)",
        height: 200,
      ),
    ];
  }

  /*List<Widget> _buildEmptyStateComponents() {
    return [
      _buildComponentCard(
        'Empty State',
        EmptyState(
          icon: Icons.inbox,
          title: 'No items yet',
          description: 'Add some items to get started.',
          action: ElevatedButton(
            onPressed: () {},
            child: const Text('Add Item'),
          ),
        ),
        "EmptyState(\n  icon: Icons.inbox,\n  title: 'No items yet',\n  description: 'Add some items to get started.',\n  action: ElevatedButton(\n    onPressed: () {},\n    child: Text('Add Item'),\n  ),\n)",
        height: 280,
      ),
    ];
  }*/

  List<Widget> _buildLoadingComponents() {
    return [
      _buildComponentCard(
        'Loading Indicator',
        HLLoadingIndicator(message: 'Loading...'),
        "HLLoadingIndicator(\n  message: 'Loading...',\n)",
        height: 200,
      ),
    ];
  }

  Widget _buildComponentCard(
    String title,
    Widget component,
    String code, {
    double height = 180,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          width: 320,
          height: height,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showCodeDialog(context, title, code),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.code,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: component,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCodeDialog(BuildContext context, String title, String code) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      ),
                    ),
                    child: SelectableText(
                      code,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Color(0xFFE2E8F0),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Code copied to clipboard!'),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Colors.white),
                    label: const Text(
                      'Copy Code',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
