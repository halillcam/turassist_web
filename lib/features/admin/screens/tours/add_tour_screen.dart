import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class AddTourScreen extends StatefulWidget {
  const AddTourScreen({super.key});

  @override
  State<AddTourScreen> createState() => _AddTourScreenState();
}

class _AddTourScreenState extends State<AddTourScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quotaController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _guideNameController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _programController = TextEditingController();
  final _vehicleInfoController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _driverPhoneController = TextEditingController();
  final _plateController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quotaController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _imageUrlController.dispose();
    _guideNameController.dispose();
    _departureDateController.dispose();
    _departureTimeController.dispose();
    _programController.dispose();
    _vehicleInfoController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Firestore'a tur eklenecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addTour)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.addTour,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Tur Başlığı',
                      controller: _titleController,
                      validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Fiyat',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Kontenjan',
                      controller: _quotaController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Şehir',
                      controller: _cityController,
                      validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(label: 'Bölge', controller: _regionController),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(label: 'Görsel URL', controller: _imageUrlController),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(label: 'Rehber Adı', controller: _guideNameController),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Çıkış Takvimi',
                      controller: _departureDateController,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Çıkış Saati',
                      controller: _departureTimeController,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Araç Bilgileri',
                      controller: _vehicleInfoController,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(label: 'Şoför Adı', controller: _driverNameController),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(
                      label: 'Şoför Telefonu',
                      controller: _driverPhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: CustomTextField(label: 'Plaka', controller: _plateController),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(label: 'Açıklama', controller: _descriptionController, maxLines: 3),
              CustomTextField(label: 'Tur Programı', controller: _programController, maxLines: 5),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.save,
                onPressed: _handleSave,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
