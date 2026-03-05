import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class AddParticipantScreen extends StatefulWidget {
  final String tourId;

  const AddParticipantScreen({super.key, required this.tourId});

  @override
  State<AddParticipantScreen> createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAddParticipant() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Firebase Auth ile kullanıcı oluşturulacak
    // Oluşturulan kullanıcı ilgili tur'a katılımcı olarak eklenecek
    // Mobil app'te giriş yapınca direkt tur detayına gidecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addParticipant)),
      body: Center(
        child: Card(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.addParticipant,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Oluşturulan ID ve şifre ile mobil uygulamadan giriş yapılabilir.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'E-posta (ID)',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Şifre',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: AppStrings.add,
                      onPressed: _handleAddParticipant,
                      isLoading: _isLoading,
                      icon: Icons.person_add,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
