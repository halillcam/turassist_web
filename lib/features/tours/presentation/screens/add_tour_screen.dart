import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/tour_image_upload_service.dart';
import '../../domain/entities/tour_entity.dart';
import '../controllers/tour_controller.dart';
import '../widgets/tour_image_upload_field.dart';

class AddTourScreen extends StatefulWidget {
  final String companyId;

  const AddTourScreen({super.key, required this.companyId});

  @override
  State<AddTourScreen> createState() => _AddTourScreenState();
}

class _AddTourScreenState extends State<AddTourScreen> {
  late final TourController _controller;
  final _imageUploadService = TourImageUploadService();
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _extraDetailCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _guideNameCtrl = TextEditingController();
  final _departureTimeCtrl = TextEditingController();
  final _driverNameCtrl = TextEditingController();
  final _driverPhoneCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  final List<int> _selectedDepartureDays = [];
  final List<DateTime> _selectedDates = [];
  final List<_ProgramDay> _programDays = [];

  String _selectedRegion = 'Marmara';
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _uploadedImageFileName;

  static const _regions = [
    'Akdeniz',
    'Karadeniz',
    'Marmara',
    'Ege',
    'İç Anadolu',
    'Doğu Anadolu',
    'Güneydoğu Anadolu',
    'Günü Birlik',
    'Yurtdışı',
  ];

  static const _weekDayLabels = {
    1: 'Pzt',
    2: 'Sal',
    3: 'Çar',
    4: 'Per',
    5: 'Cum',
    6: 'Cmt',
    7: 'Paz',
  };

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TourController>();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _extraDetailCtrl.dispose();
    _priceCtrl.dispose();
    _capacityCtrl.dispose();
    _cityCtrl.dispose();
    _imageUrlCtrl.dispose();
    _guideNameCtrl.dispose();
    _departureTimeCtrl.dispose();
    _driverNameCtrl.dispose();
    _driverPhoneCtrl.dispose();
    _plateCtrl.dispose();
    for (final d in _programDays) {
      d.dispose();
    }
    super.dispose();
  }

  // ─── Program ─────────────────────────────────────────────────────────────

  void _addProgramDay() {
    setState(() {
      _programDays.add(
        _ProgramDay(
          titleCtrl: TextEditingController(text: '${_programDays.length + 1}. Gün'),
          activityCtrls: [TextEditingController()],
        ),
      );
    });
  }

  void _removeProgramDay(int index) {
    setState(() => _programDays.removeAt(index).dispose());
  }

  void _addActivity(int dayIndex) {
    setState(() => _programDays[dayIndex].activityCtrls.add(TextEditingController()));
  }

  void _removeActivity(int dayIndex, int actIndex) {
    if (_programDays[dayIndex].activityCtrls.length <= 1) return;
    setState(() => _programDays[dayIndex].activityCtrls.removeAt(actIndex).dispose());
  }

  List<DayProgramEntity> _buildProgram() {
    final result = <DayProgramEntity>[];
    for (int i = 0; i < _programDays.length; i++) {
      final day = _programDays[i];
      final title = day.titleCtrl.text.trim();
      final activities = day.activityCtrls
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      if (activities.isNotEmpty) {
        result.add(
          DayProgramEntity(
            id: '',
            title: title.isEmpty ? '${i + 1}. Gün' : title,
            day: i + 1,
            order: i + 1,
            activities: activities,
          ),
        );
      }
    }
    return result;
  }

  // ─── Date Picker ─────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;
    final normalized = DateTime(date.year, date.month, date.day);
    if (_selectedDates.any(
      (d) => d.year == normalized.year && d.month == normalized.month && d.day == normalized.day,
    )) {
      return;
    }
    setState(() => _selectedDates.add(normalized));
  }

  // ─── Save ─────────────────────────────────────────────────────────────────

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isUploadingImage) {
      _showSnackBar('Görsel yükleme devam ediyor. Lütfen bekleyin.', isError: true);
      return;
    }
    if (_selectedDepartureDays.isEmpty && _selectedDates.isEmpty) {
      _showSnackBar('En az bir çıkış günü veya özel tarih seçmelisiniz.', isError: true);
      return;
    }

    final program = _buildProgram();
    if (program.isEmpty) {
      _showSnackBar('En az bir program günü ve aktivite eklemelisiniz.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final companyName = await _controller.fetchCompanyName(widget.companyId);

      final tour = TourEntity(
        id: '',
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        extraDetail: _extraDetailCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text) ?? 0,
        imageUrl: _imageUrlCtrl.text.trim(),
        companyId: widget.companyId,
        companyName: companyName,
        guideName: _guideNameCtrl.text.trim().isEmpty ? null : _guideNameCtrl.text.trim(),
        guideId: '',
        capacity: int.tryParse(_capacityCtrl.text) ?? 0,
        city: _cityCtrl.text.trim(),
        region: _selectedRegion,
        busInfo: BusInfoEntity(
          driverName: _driverNameCtrl.text.trim(),
          phoneNumber: _driverPhoneCtrl.text.trim(),
          plate: _plateCtrl.text.trim(),
          capacity: int.tryParse(_capacityCtrl.text) ?? 0,
        ),
        program: program,
        departureDays: List.from(_selectedDepartureDays),
        departureTime: _departureTimeCtrl.text.trim(),
        departureDates: _selectedDates.isNotEmpty ? List.from(_selectedDates) : null,
        isDeleted: false,
      );

      final success = await _controller.addTourSeries(tour);
      if (success && mounted) {
        _showSnackBar('Tur serisi oluşturuldu.');
        _clearForm();
      }
    } catch (e) {
      _showSnackBar('Hata: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _titleCtrl.clear();
    _descriptionCtrl.clear();
    _extraDetailCtrl.clear();
    _priceCtrl.clear();
    _capacityCtrl.clear();
    _cityCtrl.clear();
    _imageUrlCtrl.clear();
    _guideNameCtrl.clear();
    _departureTimeCtrl.clear();
    _driverNameCtrl.clear();
    _driverPhoneCtrl.clear();
    _plateCtrl.clear();
    for (final d in _programDays) {
      d.dispose();
    }
    setState(() {
      _programDays.clear();
      _selectedDepartureDays.clear();
      _selectedDates.clear();
      _selectedRegion = 'Marmara';
      _uploadedImageFileName = null;
    });
  }

  // ─── Image Upload ─────────────────────────────────────────────────────────

  Future<void> _pickAndUploadImage() async {
    if (_isUploadingImage || _isLoading) return;
    setState(() => _isUploadingImage = true);
    try {
      final uploaded = await _imageUploadService.pickAndUpload(
        companyId: widget.companyId,
        uploaderRole: _controller.isSuperAdmin ? 'super_admin' : 'admin',
      );
      if (uploaded == null) return;
      if (_imageUrlCtrl.text.trim().isNotEmpty) {
        await _imageUploadService.deleteByUrl(_imageUrlCtrl.text.trim());
      }
      setState(() {
        _imageUrlCtrl.text = uploaded.downloadUrl;
        _uploadedImageFileName = uploaded.fileName;
      });
      _showSnackBar('Görsel Firebase Storage alanına yüklendi.');
    } catch (e) {
      _showSnackBar(_friendlyUploadError(e), isError: true);
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _removeUploadedImage() async {
    final url = _imageUrlCtrl.text.trim();
    if (url.isEmpty) return;
    setState(() => _isUploadingImage = true);
    try {
      await _imageUploadService.deleteByUrl(url);
      setState(() {
        _imageUrlCtrl.clear();
        _uploadedImageFileName = null;
      });
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  String _friendlyUploadError(Object error) {
    final msg = error.toString();
    if (msg.contains('object-not-found')) {
      return 'Yüklenen görsel Firebase Storage üzerinde bulunamadı.';
    }
    if (msg.contains('unauthorized') || msg.contains('permission-denied')) {
      return 'Firebase Storage yazma izni yok.';
    }
    if (msg.contains('bucket-not-found')) {
      return 'Firebase Storage bucket bulunamadı.';
    }
    return 'Görsel yüklenemedi: $msg';
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? AppColors.error : AppColors.success),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

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
              _sectionHeader(Icons.info_outline, 'Temel Bilgiler'),
              const SizedBox(height: 16),
              _buildBasicInfoSection(),
              const SizedBox(height: 32),
              _sectionHeader(Icons.directions_bus, 'Araç Bilgileri'),
              const SizedBox(height: 16),
              _buildBusInfoSection(),
              const SizedBox(height: 32),
              _sectionHeader(Icons.calendar_month, 'Çıkış Takvimi'),
              const SizedBox(height: 16),
              _buildDepartureSection(),
              const SizedBox(height: 32),
              _sectionHeader(Icons.list_alt, 'Tur Programı'),
              const SizedBox(height: 16),
              _buildProgramSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _field('Tur Başlığı *', _titleCtrl, width: 350, required: true),
            _field(
              'Fiyat (₺) *',
              _priceCtrl,
              width: 200,
              keyboard: TextInputType.number,
              required: true,
            ),
            _field(
              'Kontenjan *',
              _capacityCtrl,
              width: 200,
              keyboard: TextInputType.number,
              required: true,
            ),
            _field('Şehir *', _cityCtrl, width: 250, required: true),
            _regionDropdown(),
            _buildImageUploadField(),
            _field('Rehber Adı', _guideNameCtrl, width: 250),
            _field(
              'Çıkış Saati *',
              _departureTimeCtrl,
              width: 200,
              hint: 'Örn: 09:00',
              required: true,
            ),
            SizedBox(
              width: double.infinity,
              child: _field('Açıklama *', _descriptionCtrl, maxLines: 3, required: true),
            ),
            SizedBox(
              width: double.infinity,
              child: _field('Ekstra Detay', _extraDetailCtrl, maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _field('Şoför Adı', _driverNameCtrl, width: 250),
            _field('Şoför Telefonu', _driverPhoneCtrl, width: 250, keyboard: TextInputType.phone),
            _field('Plaka', _plateCtrl, width: 200),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Haftalık Çıkış Günleri',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _weekDayLabels.entries.map((entry) {
                final isSelected = _selectedDepartureDays.contains(entry.key);
                return FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withAlpha(50),
                  checkmarkColor: AppColors.primary,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDepartureDays.add(entry.key);
                      } else {
                        _selectedDepartureDays.remove(entry.key);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_selectedDepartureDays.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Seçili: ${_selectedDepartureDays.map((d) => _weekDayLabels[d]).join(", ")}',
                style: const TextStyle(color: AppColors.primary, fontSize: 12),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Özel Çıkış Tarihleri',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            if (_selectedDates.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedDates
                    .map(
                      (date) => Chip(
                        label: Text(DateFormat('dd.MM.yyyy').format(date)),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => _selectedDates.remove(date)),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tarih Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < _programDays.length; i++) _buildProgramDayCard(i),
            OutlinedButton.icon(
              onPressed: _addProgramDay,
              icon: const Icon(Icons.add, size: 18),
              label: Text(_programDays.isEmpty ? 'Program Günü Ekle' : 'Yeni Gün Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDayCard(int dayIndex) {
    final day = _programDays[dayIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: day.titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Gün Başlığı',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _removeProgramDay(dayIndex),
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Aktiviteler', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(height: 8),
          for (int j = 0; j < day.activityCtrls.length; j++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: day.activityCtrls[j],
                      decoration: InputDecoration(
                        labelText: '${j + 1}. Aktivite',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (day.activityCtrls.length > 1)
                    IconButton(
                      onPressed: () => _removeActivity(dayIndex, j),
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          TextButton.icon(
            onPressed: () => _addActivity(dayIndex),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Aktivite Ekle', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleSave,
        icon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.save),
        label: Text(_isLoading ? 'Kaydediliyor...' : AppStrings.save),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildImageUploadField() {
    return TourImageUploadField(
      isUploading: _isUploadingImage,
      imageUrlController: _imageUrlCtrl,
      imageUrl: _imageUrlCtrl.text,
      uploadedImageFileName: _uploadedImageFileName,
      onUploadPressed: _pickAndUploadImage,
      onRemovePressed: _removeUploadedImage,
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    double? width,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    bool required = false,
    String? hint,
  }) {
    final field = TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    return width != null ? SizedBox(width: width, child: field) : field;
  }

  Widget _regionDropdown() {
    return SizedBox(
      width: 250,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedRegion,
        decoration: InputDecoration(
          labelText: 'Bölge *',
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: _regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() => _selectedRegion = val);
          }
        },
      ),
    );
  }
}

// ─── Program Day Helper ────────────────────────────────────────────────────

class _ProgramDay {
  final TextEditingController titleCtrl;
  final List<TextEditingController> activityCtrls;

  _ProgramDay({required this.titleCtrl, required this.activityCtrls});

  void dispose() {
    titleCtrl.dispose();
    for (final c in activityCtrls) {
      c.dispose();
    }
  }
}
