import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterRoleScreen extends StatefulWidget {
  const RegisterRoleScreen({super.key});

  @override
  State<RegisterRoleScreen> createState() => _RegisterRoleScreenState();
}

class _RegisterRoleScreenState extends State<RegisterRoleScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bạn là ai?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Chọn một vai trò để trải nghiệm tốt nhất.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Role Card 1: Phụ Huynh / Học Sinh
              _buildRoleCard(
                context: context,
                title: 'Tìm Gia Sư',
                subtitle: 'Học tập hiệu quả hơn.',
                icon: Icons.school,
                roleValue: 'PARENT',
                iconBgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                isSelected: _selectedRole == 'PARENT',
                onTap: () {
                  setState(() => _selectedRole = 'PARENT');
                },
              ),
              const SizedBox(height: 16),

              // Role Card 2: Gia Sư
              _buildRoleCard(
                context: context,
                title: 'Làm Gia Sư',
                subtitle: 'Kiếm thu nhập từ việc dạy.',
                icon: Icons.person_search,
                roleValue: 'TUTOR',
                iconBgColor: Colors.indigo.shade100,
                iconColor: Colors.indigo,
                isSelected: _selectedRole == 'TUTOR',
                onTap: () {
                  setState(() => _selectedRole = 'TUTOR');
                },
              ),

              const Spacer(),

              // Footer Actions
              ElevatedButton(
                onPressed: _selectedRole == null
                    ? null
                    : () {
                        // TODO: Navigate to full register form with _selectedRole
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Chuyển tới đăng ký: $_selectedRole')),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tiếp Tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                    // Optionally push back Login sheet if requested
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Đã có tài khoản? ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Đăng nhập',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String roleValue,
    required Color iconBgColor,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: colorScheme.primary, width: 2)
              : const BorderSide(color: Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Radio<String>(
                value: roleValue,
                groupValue: _selectedRole,
                onChanged: (_) => onTap(),
                activeColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
