import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../student/presentation/cubit/ai_cubit.dart';
import '../../../student/presentation/screens/ai_chat_screen.dart';

/// AI hỗ trợ học tập — entry point từ Bottom Navigation Tab AI.
/// Wrap AiChatScreen với BlocProvider<AiCubit>.
class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiCubit(),
      child: const AiChatScreen(),
    );
  }
}
