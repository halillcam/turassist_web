import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/tour_model.dart';
import '../../../../core/services/tour_image_upload_service.dart';
import '../../services/super_admin_service.dart';

class SaAddTourScreen extends StatefulWidget {
  final String companyId;
  const SaAddTourScreen({super.key, required this.companyId});

  @override
  State<SaAddTourScreen> createState() => _SaAddTourScreenState();
}

class _SaAddTourScreenState extends State<SaAddTourScreen> {
  final _service = SuperAdminService();
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
  final _busCapacityCtrl = TextEditingController();

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
    _busCapacityCtrl.dispose();
    for (final day in _programDays) {
      day.dispose();
    }
    super.dispose();
  }

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
    setState(() {
      _programDays[dayIndex].activityCtrls.add(TextEditingController());
    });
  }

  void _removeActivity(int dayIndex, int actIndex) {
    if (_programDays[dayIndex].activityCtrls.length <= 1) return;
    setState(() {
      _programDays[dayIndex].activityCtrls.removeAt(actIndex).dispose();
    });
  }

  List<DayProgram> _buildProgram() {
    final result = <DayProgram>[];
    for (int i = 0; i < _programDays.length; i++) {
      final day = _programDays[i];
      final title = day.titleCtrl.text.trim();
      final activities = day.activityCtrls
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      if (activities.isNotEmpty) {
        result.add(
          DayProgram(
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isUploadingImage) {
      Get.snackbar(
        'Uyarı',
        'Görsel yükleme devam ediyor. Lütfen bekleyin.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedDepartureDays.isEmpty && _selectedDates.isEmpty) {
      Get.snackbar(
        'Uyarı',
        'En az bir çıkış günü veya tarih seçmelisiniz.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final company = await _service.getCompany(widget.companyId);
      final companyName = company?.companyName ?? '';

      final tour = TourModel(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        extraDetail: _extraDetailCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text) ?? 0,
        imageUrl: _imageUrlCtrl.text.trim(),
        companyId: widget.companyId,
        companyName: companyName,
        guideName: _guideNameCtrl.text.trim().isEmpty ? null : _guideNameCtrl.text.trim(),
        capacity: int.tryParse(_capacityCtrl.text) ?? 0,
        city: _cityCtrl.text.trim(),
        region: _selectedRegion,
        busInfo: BusInfo(
          driverName: _driverNameCtrl.text.trim(),
          phoneNumber: _driverPhoneCtrl.text.trim(),
          plate: _plateCtrl.text.trim(),
          capacity: int.tryParse(_busCapacityCtrl.text) ?? 0,
        ),
        program: _buildProgram(),
        departureDays: List.from(_selectedDepartureDays),
        departureTime: _departureTimeCtrl.text.trim(),
        departureDates: _selectedDates.isNotEmpty ? List.from(_selectedDates) : null,
        seriesId: 'series_${DateTime.now().microsecondsSinceEpoch}',
      );

      await _service.addTour(tour);
      Get.snackbar('Başarılı', 'Tur başarıyla eklendi.', snackPosition: SnackPosition.BOTTOM);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_isUploadingImage || _isLoading) return;

    setState(() => _isUploadingImage = true);
    try {
      final uploaded = await _imageUploadService.pickAndUpload(
        companyId: widget.companyId,
        uploaderRole: 'super_admin',
      );

      if (uploaded == null) return;

      if (_imageUrlCtrl.text.trim().isNotEmpty) {
        await _imageUploadService.deleteByUrl(_imageUrlCtrl.text.trim());
      }

      setState(() {
        _imageUrlCtrl.text = uploaded.downloadUrl;
        _uploadedImageFileName = uploaded.fileName;
      });

      Get.snackbar(
        'Başarılı',
        'Görsel Firebase Storage alanına yüklendi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Hata', _friendlyUploadError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  Future<void> _removeUploadedImage() async {
    final existingUrl = _imageUrlCtrl.text.trim();
    if (existingUrl.isEmpty) return;

    setState(() => _isUploadingImage = true);
    try {
      await _imageUploadService.deleteByUrl(existingUrl);
      setState(() {
        _imageUrlCtrl.clear();
        _uploadedImageFileName = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  String _friendlyUploadError(Object error) {
    final message = error.toString();
    if (message.contains('object-not-found')) {
      return 'Yüklenen görsel Firebase Storage üzerinde bulunamadı.';
    }
    if (message.contains('unauthorized') || message.contains('permission-denied')) {
      return 'Firebase Storage yazma izni yok. Storage kuralları veya bucket ayarı kontrol edilmeli.';
    }
    if (message.contains('bucket-not-found')) {
      return 'Firebase Storage bucket bulunamadı. Firebase tarafında Storage etkinleştirilmeli.';
    }
    return 'Görsel yüklenemedi: $message';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addTour),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              SizedBox(
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
              ),
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
            _field('Araç Kapasitesi', _busCapacityCtrl, width: 200, keyboard: TextInputType.number),
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
                children: _selectedDates.map((date) {
                  return Chip(
                    label: Text(DateFormat('dd.MM.yyyy').format(date)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _selectedDates.remove(date)),
                  );
                }).toList(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tur Programı',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                OutlinedButton.icon(
                  onPressed: _addProgramDay,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Gün Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _programDays.length; i++) ...[
              _buildProgramDayCard(i),
              const SizedBox(height: 12),
            ],
            if (_programDays.isEmpty)
              const Text(
                'Henüz program günü eklenmedi.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDayCard(int dayIndex) {
    final day = _programDays[dayIndex];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.slate200),
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
                icon: const Icon(Icons.delete, color: AppColors.error),
                tooltip: 'Günü Sil',
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int j = 0; j < day.activityCtrls.length; j++) ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: day.activityCtrls[j],
                    decoration: InputDecoration(
                      labelText: 'Aktivite ${j + 1}',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _removeActivity(dayIndex, j),
                  icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addActivity(dayIndex),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Aktivite Ekle'),
            ),
          ),
        ],
      ),
    );
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
          if (val != null) setState(() => _selectedRegion = val);
        },
      ),
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

  Widget _buildImageUploadField() {
    final hasImage = _imageUrlCtrl.text.trim().isNotEmpty;
    return SizedBox(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: _isUploadingImage ? null : _pickAndUploadImage,
            icon: _isUploadingImage
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file),
            label: Text(_isUploadingImage ? 'Yükleniyor...' : 'Görsel Ekle'),
          ),
          const SizedBox(height: 8),
          Text(
            hasImage
                ? (_uploadedImageFileName ?? 'Firebase Storage görseli hazır')
                : 'Dosya seçildiğinde bilgisayarınızdaki pencere açılır ve görsel Firebase Storage alanına yüklenir.',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          if (hasImage) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _imageUrlCtrl.text.trim(),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 150,
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: const Text('Görsel önizlemesi alınamadı'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    _imageUrlCtrl.text.trim(),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
                IconButton(
                  onPressed: _isUploadingImage ? null : _removeUploadedImage,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  tooltip: 'Görseli kaldır',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

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
