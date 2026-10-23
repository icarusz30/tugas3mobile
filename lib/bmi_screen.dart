
import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _bbController = TextEditingController();
  final _tbController = TextEditingController();

  double? _hasilBMI;
  String _keterangan = 'Masukkan data untuk menghitung BMI';
  String _jenisKelamin = 'Laki-laki';
  String? _pesanError;

  @override
  void dispose() {
    _bbController.dispose();
    _tbController.dispose();
    super.dispose();
  }

  void _hitungBMI() {
    final bb = double.tryParse(
      _bbController.text.trim().replaceAll(',', '.'),
    );

    final tbCm = double.tryParse(
      _tbController.text.trim().replaceAll(',', '.'),
    );

    if (bb == null ||
        tbCm == null ||
        !bb.isFinite ||
        !tbCm.isFinite ||
        bb <= 0 ||
        tbCm <= 0) {
      setState(() {
        _hasilBMI = null;
        _keterangan = 'Data belum valid';
        _pesanError = 'Masukkan berat dan tinggi badan yang benar.';
      });
      return;
    }

    final tbM = tbCm / 100;
    final bmi = bb / (tbM * tbM);

    setState(() {
      _hasilBMI = bmi;
      _pesanError = null;

      if (bmi < 18.5) {
        _keterangan = 'Berat Badan Kurang';
      } else if (bmi < 25) {
        _keterangan = 'Berat Badan Normal';
      } else if (bmi < 30) {
        _keterangan = 'Berat Badan Berlebih';
      } else {
        _keterangan = 'Obesitas';
      }
    });
  }

  void _resetBMI() {
    _bbController.clear();
    _tbController.clear();

    setState(() {
      _hasilBMI = null;
      _jenisKelamin = 'Laki-laki';
      _keterangan = 'Masukkan data untuk menghitung BMI';
      _pesanError = null;
    });

    FocusScope.of(context).unfocus();
  }

  Color _warnaHasil() {
    if (_hasilBMI == null) return const Color(0xFF64748B);

    if (_hasilBMI! < 18.5) return const Color(0xFF2563EB);
    if (_hasilBMI! < 25) return const Color(0xFF16A34A);
    if (_hasilBMI! < 30) return const Color(0xFFF59E0B);

    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    const biru = Color(0xFF1D4ED8);
    const latar = Color(0xFFF3F7F6);

    return Scaffold(
      backgroundColor: latar,
      appBar: AppBar(
        backgroundColor: biru,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Kalkulator BMI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        leading: const Icon(Icons.monitor_heart),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1D4ED8),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kenali Kondisi Tubuhmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Hitung indeks massa tubuh dengan mudah.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Data Pribadi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 14),

              // INPUT BERAT BADAN
              _buildInput(
                controller: _bbController,
                label: 'Berat Badan (kg)',
                icon: Icons.monitor_weight_outlined,
                hint: 'Contoh: 50',
              ),

              const SizedBox(height: 14),

              // INPUT TINGGI BADAN
              _buildInput(
                controller: _tbController,
                label: 'Tinggi Badan (cm)',
                icon: Icons.height,
                hint: 'Contoh: 165',
              ),

              const SizedBox(height: 14),

              // PILIH JENIS KELAMIN
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _genderOption(
                            label: 'Laki-laki',
                            icon: Icons.male,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _genderOption(
                            label: 'Perempuan',
                            icon: Icons.female,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (_pesanError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _pesanError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // TOMBOL HITUNG
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _hitungBMI,
                  icon: const Icon(Icons.calculate),
                  label: const Text(
                    'Hitung BMI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: biru,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // TOMBOL RESET
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _resetBMI,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: biru,
                    side: const BorderSide(color: biru),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // HASIL BMI
              const Text(
                'Hasil Perhitungan',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.monitor_heart_outlined,
                      size: 40,
                      color: _warnaHasil(),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'BMI KAMU',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _hasilBMI?.toStringAsFixed(1) ?? '--',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: _warnaHasil(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: _warnaHasil().withOpacity(0.10),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        _keterangan,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _warnaHasil(),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_hasilBMI != null) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _jenisKelamin == 'Laki-laki'
                                ? Icons.male
                                : Icons.female,
                            color: biru,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Hasil BMI ${_jenisKelamin}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: biru,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // PANDUAN KATEGORI
              const Text(
                'Panduan Kategori BMI Dewasa',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildCategory(
                'Di bawah 18,5',
                'Berat badan kurang',
                const Color(0xFF2563EB),
              ),
              _buildCategory(
                '18,5 – 24,9',
                'Berat badan normal',
                const Color(0xFF16A34A),
              ),
              _buildCategory(
                '25,0 – 29,9',
                'Berat badan berlebih',
                const Color(0xFFF59E0B),
              ),
              _buildCategory(
                '30 atau lebih',
                'Obesitas',
                const Color(0xFFDC2626),
              ),

              const SizedBox(height: 16),

              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF1D4ED8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF1D4ED8),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _genderOption({
    required String label,
    required IconData icon,
  }) {
    final selected = _jenisKelamin == label;

    return InkWell(
      onTap: () {
        setState(() {
          _jenisKelamin = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEFF6FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF1D4ED8)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: selected
                  ? const Color(0xFF1D4ED8)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: selected
                    ? const Color(0xFF1D4ED8)
                    : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
    String rentang,
    String label,
    Color warna,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 38,
            decoration: BoxDecoration(
              color: warna,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rentang,
                  style: TextStyle(
                    color: warna,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
