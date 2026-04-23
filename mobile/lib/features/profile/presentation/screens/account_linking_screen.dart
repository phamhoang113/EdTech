import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/datasources/social_auth_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Screen cho phép user quản lý liên kết tài khoản OAuth2 (Google/Facebook)
/// Tương tự như màn AccountLinkingSettings bên Web.
class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  final _dio = getIt<DioClient>().dio;
  final _socialAuth = getIt<SocialAuthService>();

  bool _isLoading = true;
  List<Map<String, dynamic>> _providers = [];

  bool _showPasswordForm = false;
  final _newPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchProviders() async {
    setState(() => _isLoading = true);
    try {
      final res = await _dio.get('/api/v1/auth/linked-providers');
      final dataList = res.data['data'] as List;
      setState(() {
        _providers = dataList.map((e) => e as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách tài khoản liên kết', style: TextStyle(color: Colors.white)), backgroundColor: AppTheme.error),
      );
    }
  }

  Future<void> _handleLink(String providerId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final idToken = providerId == 'google'
          ? await _socialAuth.signInWithGoogle()
          : await _socialAuth.signInWithFacebook();

      if (idToken == null) {
        if (mounted) context.pop(); // close loading
        return;
      }

      await _dio.post('/api/v1/auth/link-provider', data: {'idToken': idToken});

      if (mounted) {
        context.pop(); // close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã liên kết $providerId thành công', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        _fetchProviders();
      }
    } on DioException catch (e) {
      if (mounted) {
        context.pop();
        final msg = e.response?.data?['message'] ?? 'Liên kết thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: AppTheme.error),
        );
      }
    } catch (e) {
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString(), style: const TextStyle(color: Colors.white)), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  Future<void> _handleUnlink(String providerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc muốn hủy liên kết tài khoản $providerId này không?'),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Hủy liên kết'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await _dio.delete('/api/v1/auth/unlink-provider', queryParameters: {'provider': providerId});

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã hủy liên kết $providerId', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
        _fetchProviders();
      }
    } on DioException catch (e) {
      if (mounted) {
        context.pop();
        final msg = e.response?.data?['message'] ?? 'Hủy liên kết thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  Future<void> _handleSetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final username = authState.user.phoneNumber;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await _dio.post('/api/v1/auth/set-password', data: {
        'username': username,
        'newPassword': _newPasswordCtrl.text,
      });

      if (mounted) {
        context.pop();
        setState(() {
          _showPasswordForm = false;
          _newPasswordCtrl.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiết lập mật khẩu thành công. Bạn có thể dùng SĐT + Mật khẩu này để đăng nhập.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        context.pop();
        final msg = e.response?.data?['message'] ?? 'Thiết lập mật khẩu thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final hasGoogle = _providers.any((p) => p['provider'] == 'google');
    final hasFacebook = _providers.any((p) => p['provider'] == 'facebook');
    final googleEmail = _providers.firstWhere((p) => p['provider'] == 'google', orElse: () => {})['providerEmail'] as String?;
    final facebookEmail = _providers.firstWhere((p) => p['provider'] == 'facebook', orElse: () => {})['providerEmail'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liên kết tài khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Tài khoản mạng xã hội', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('Liên kết mạng xã hội giúp bạn đăng nhập nhanh chóng chỉ với 1 chạm.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),

            // Google
            _ProviderRow(
              iconHtml: 'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
              iconName: 'Google',
              linkedEmail: googleEmail,
              isLinked: hasGoogle,
              onLink: () => _handleLink('google'),
              onUnlink: () => _handleUnlink('google'),
            ),
            const SizedBox(height: 12),

            // Facebook
            _ProviderRow(
              iconData: Icons.facebook,
              iconColor: const Color(0xFF1877F2),
              iconName: 'Facebook',
              linkedEmail: facebookEmail,
              isLinked: hasFacebook,
              onLink: () => _handleLink('facebook'),
              onUnlink: () => _handleUnlink('facebook'),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text('Mật khẩu độc lập', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('Thiết lập mật khẩu để có thể đăng nhập bằng Số điện thoại mà không cần mạng xã hội.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),

            if (!_showPasswordForm)
              OutlinedButton(
                onPressed: () => setState(() => _showPasswordForm = true),
                child: const Text('Thiết lập mật khẩu'),
              )
            else
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu mới',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'Tối thiểu 6 ký tự' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              _showPasswordForm = false;
                              _newPasswordCtrl.clear();
                            }),
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _handleSetPassword,
                            child: const Text('Lưu'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  final String? iconHtml;
  final IconData? iconData;
  final Color? iconColor;
  final String iconName;
  final String? linkedEmail;
  final bool isLinked;
  final VoidCallback onLink;
  final VoidCallback onUnlink;

  const _ProviderRow({
    this.iconHtml,
    this.iconData,
    this.iconColor,
    required this.iconName,
    this.linkedEmail,
    required this.isLinked,
    required this.onLink,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (iconHtml != null)
            Image.network(iconHtml!, width: 28, height: 28)
          else if (iconData != null)
            Icon(iconData, size: 28, color: iconColor),
          
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(iconName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                if (isLinked && linkedEmail != null)
                  Text(linkedEmail!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (isLinked)
            OutlinedButton(
              onPressed: onUnlink,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Hủy liên kết'),
            )
          else
            ElevatedButton(
              onPressed: onLink,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('Liên kết'),
            ),
        ],
      ),
    );
  }
}
