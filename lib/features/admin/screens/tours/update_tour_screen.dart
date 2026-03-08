import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../controllers/admin_tour_controller.dart';

class UpdateTourScreen extends StatefulWidget {
  final String tourId;

  const UpdateTourScreen({super.key, required this.tourId});

  @override
  State<UpdateTourScreen> createState() => _UpdateTourScreenState();
}

class _UpdateTourScreenState extends State<UpdateTourScreen> {
  late final AdminTourController _controller;
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
  String _selectedRegion = 'Marmara';

  bool _isLoading = false;
  bool _isDataLoaded = false;

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
    _controller = Get.find<AdminTourController>();
    _loadTourData();
  }

  Future<void> _loadTourData() async {
    final tour = await _controller.getTour(widget.tourId);
    if (tour == null || !mounted) return;

    _titleCtrl.text = tour.title;
    _descriptionCtrl.text = tour.description;
    _extraDetailCtrl.text = tour.extraDetail;
    _priceCtrl.text = tour.price.toStringAsFixed(0);
    _capacityCtrl.text = tour.capacity.toString();
    _cityCtrl.text = tour.city;
    _imageUrlCtrl.text = tour.imageUrl;
    _guideNameCtrl.text = tour.guideName ?? '';
    _departureTimeCtrl.text = tour.departureTime;
    _driverNameCtrl.text = tour.busInfo.driverName;
    _driverPhoneCtrl.text = tour.busInfo.phoneNumber;
    _plateCtrl.text = tour.busInfo.plate;
    _busCapacityCtrl.text = tour.busInfo.capacity.toString();

    setState(() {
      _selectedRegion = _regions.contains(tour.region) ? tour.region : 'Marmara';
      _selectedDepartureDays
        ..clear()
        ..addAll(tour.departureDays);
      _selectedDates
        ..clear()
        ..addAll(tour.departureDates ?? []);
      _isDataLoaded = true;
    });
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
    _busCapacityCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final data = {
        'title': _titleCtrl.text.trim(),
        'description': _descriptionCtrl.text.trim(),
        'extraDetail': _extraDetailCtrl.text.trim(),
        'price': double.tryParse(_priceCtrl.text) ?? 0,
        'capacity': int.tryParse(_capacityCtrl.text) ?? 0,
        'city': _cityCtrl.text.trim(),
        'region': _selectedRegion,
        'imageUrl': _imageUrlCtrl.text.trim(),
        'guideName': _guideNameCtrl.text.trim().isEmpty ? null : _guideNameCtrl.text.trim(),
        'departureTime': _departureTimeCtrl.text.trim(),
        'departureDays': _selectedDepartureDays,
        'departureDates': _selectedDates.map((d) => DateTime(d.year, d.month, d.day)).toList(),
        'busInfo': {
          'driverName': _driverNameCtrl.text.trim(),
          'phoneNumber': _driverPhoneCtrl.text.trim(),
          'plate': _plateCtrl.text.trim(),
          'capacity': int.tryParse(_busCapacityCtrl.text) ?? 0,
        },
      };

      await _controller.updateTour(widget.tourId, data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tur başarıyla güncellendi.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.error));
    } finally {
      setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.updateTour),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(Icons.info_outline, 'Temel Bilgiler'),
                    const SizedBox(height: 16),
                    _buildBasicInfoCard(),
                    const SizedBox(height: 24),
                    _sectionHeader(Icons.directions_bus, 'Araç Bilgileri'),
                    const SizedBox(height: 16),
                    _buildBusInfoCard(),
                    const SizedBox(height: 24),
                    _sectionHeader(Icons.calendar_month, 'Çıkış Takvimi'),
                    const SizedBox(height: 16),
                    _buildDepartureCard(),
                    const SizedBox(height: 32),
                    _buildUpdateButton(),
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

  Widget _buildBasicInfoCard() {
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
            _field('Görsel URL', _imageUrlCtrl, width: 350),
            _field('Rehber Adı', _guideNameCtrl, width: 250),
            _field('Çıkış Saati', _departureTimeCtrl, width: 200),
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

  Widget _buildBusInfoCard() {
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

  Widget _buildDepartureCard() {
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

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleUpdate,
        icon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.edit),
        label: Text(_isLoading ? 'Güncelleniyor...' : AppStrings.update),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
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
  }) {
    final field = TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null : null,
      decoration: InputDecoration(
        labelText: label,
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
          labelText: 'Bölge',
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: _regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        onChanged: (v) {
          if (v != null) setState(() => _selectedRegion = v);
        },
      ),
    );
  }
}
