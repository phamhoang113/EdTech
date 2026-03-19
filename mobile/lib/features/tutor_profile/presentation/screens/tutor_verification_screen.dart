import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme.dart';
import '../../../../../core/di/injection.dart';
import '../bloc/tutor_profile_bloc.dart';
import '../bloc/tutor_profile_event.dart';
import '../bloc/tutor_profile_state.dart';

class TutorVerificationScreen extends StatefulWidget {
  const TutorVerificationScreen({super.key});

  @override
  State<TutorVerificationScreen> createState() => _TutorVerificationScreenState();
}

class _TutorVerificationScreenState extends State<TutorVerificationScreen> {
  final _bloc = getIt<TutorProfileBloc>();
  String _tutorType = 'STUDENT';
  File? _idCardFront;
  File? _idCardBack;
  File? _degree;

  final _picker = ImagePicker();

  Future<void> _pickImage(bool isFront, bool isDegree) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isDegree) {
          _degree = File(pickedFile.path);
        } else if (isFront) {
          _idCardFront = File(pickedFile.path);
        } else {
          _idCardBack = File(pickedFile.path);
        }
      });
    }
  }

  void _submit() {
    if (_idCardFront == null || _idCardBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng tải lên cả 2 mặt CCCD')),
      );
      return;
    }

    if (_degree == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng tải lên giấy tờ liên quan (Thẻ SV/Bằng cấp)')),
      );
      return;
    }

    _bloc.add(VerifyTutorProfile(
      tutorType: _tutorType,
      idCardFront: _idCardFront!,
      idCardBack: _idCardBack!,
      degree: _degree!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<TutorProfileBloc, TutorProfileState>(
        listener: (context, state) {
          if (state is TutorProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is TutorProfileVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã gửi yêu cầu xác thực thành công. Vui lòng chờ duyệt!')),
            );
            context.go('/dashboard');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Xác thực Gia sư')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Loại gia sư', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _tutorType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'STUDENT', child: Text('Sinh viên')),
                      DropdownMenuItem(value: 'TEACHER', child: Text('Giáo viên')),
                      DropdownMenuItem(value: 'GRADUATED', child: Text('Đã tốt nghiệp')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _tutorType = val;
                          _degree = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Ảnh CCCD / CMND (Bắt buộc)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _ImageUploadBox(
                        title: 'Mặt trước',
                        file: _idCardFront,
                        onTap: () => _pickImage(true, false),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _ImageUploadBox(
                        title: 'Mặt sau',
                        file: _idCardBack,
                        onTap: () => _pickImage(false, false),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(_getDegreeLabel(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _ImageUploadBox(
                    title: 'Tải lên hình ảnh',
                    file: _degree,
                    onTap: () => _pickImage(false, true),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state is TutorProfileLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: state is TutorProfileLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Gửi xác thực', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDegreeLabel() {
    switch (_tutorType) {
      case 'STUDENT': return 'Ảnh thẻ sinh viên (Bắt buộc)';
      case 'TEACHER': return 'Chứng chỉ nghiệp vụ/sư phạm (Bắt buộc)';
      case 'GRADUATED': return 'Bằng tốt nghiệp đại học/cao đẳng (Bắt buộc)';
      default: return 'Giấy tờ liên quan (Bắt buộc)';
    }
  }
}

class _ImageUploadBox extends StatelessWidget {
  final String title;
  final File? file;
  final VoidCallback onTap;

  const _ImageUploadBox({required this.title, this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
      ),
    );
  }
}
