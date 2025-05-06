import 'package:flutter/material.dart';
import 'package:pengumuman_smkn_1_maluk/model/student.dart';
import 'package:pengumuman_smkn_1_maluk/pages/loading_screen.dart';

class NisnInputPage extends StatefulWidget {
  const NisnInputPage({Key? key}) : super(key: key);

  @override
  State<NisnInputPage> createState() => _NisnInputPageState();
}

class _NisnInputPageState extends State<NisnInputPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nisnController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  // Dummy list of students
  final List<Student> _students = [
    Student(
      nisn: "63353410",
      name: "Lintang Samudra",
      school: "SMKN 1 MALUK",
      major: "TEKNIK ALAT BERAT",
      city: "Benete",
      province: "NUSA TENGGARA BARAT",
    ),
    Student(
      nisn: "67005499",
      name: "Teguh Harianto",
      school: "SMKN 1 MALUK",
      major: "TEKNIK ALAT BERAT",
      city: "Maluk",
      province: "NUSA TENGGARA BARAT",
    ),
    Student(
      nisn: "69880573",
      name: "Arcel Try Ardanu",
      school: "SMKN 1 MALUK",
      major: "Tata Boga",
      city: "Maluk",
      province: "NUSA TENGGARA BARAT",
    ),
    Student(
      nisn: "75092952",
      name: "Lalu Muhadli Ikhwan",
      school: "SMKN 1 MALUK",
      major: "TEKNIK ALAT BERAT",
      city: "Maluk",
      province: "NUSA TENGGARA BARAT",
    ),
    Student(
      nisn: "64840329",
      name: "Wahyu Pratama",
      school: "SMKN 1 MALUK",
      major: "TEKNIK ALAT BERAT",
      city: "Maluk",
      province: "NUSA TENGGARA BARAT",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _checkNisn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Show button click animation
      _buttonAnimationController.forward().then(
        (_) => _buttonAnimationController.reverse(),
      );

      // Get the input NISN
      final inputNisn = _nisnController.text.trim();

      // Find student with matching NISN
      final foundStudent =
          _students.where((student) => student.nisn == inputNisn).toList();

      if (foundStudent.isNotEmpty) {
        // Reset loading state before navigation
        setState(() {
          _isLoading = false;
        });

        // Navigate to loading screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    LoadingScreen(nisn: inputNisn, student: foundStudent[0]),
          ),
        ).then((_) {
          // Ensure loading state is reset when returning to this screen
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      } else {
        // Add a small delay to make the UI feel more responsive
        await Future.delayed(const Duration(milliseconds: 300));

        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'NISN tidak ditemukan. Silakan periksa kembali.',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nisnController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/logo_sekolah.png',
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image not found
                              return Container(
                                height: 100,
                                width: 100,
                                color: Colors.blue.shade100,
                                child: Icon(
                                  Icons.school,
                                  size: 60,
                                  color: Colors.blue.shade700,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'PENGUMUMAN KELULUSAN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            'TAHUN PELAJARAN 2024/2025',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: const Text(
                              'Masukkan NISN Anda untuk melihat hasil kelulusan',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nisnController,
                            decoration: InputDecoration(
                              labelText: 'NISN',
                              hintText: 'Masukkan NISN Anda',
                              prefixIcon: const Icon(Icons.badge),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _nisnController.clear(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NISN tidak boleh kosong';
                              }
                              if (value.length < 4) {
                                return 'NISN terlalu pendek';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _checkNisn(),
                          ),
                          const SizedBox(height: 30),
                          AnimatedBuilder(
                            animation: _buttonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonScaleAnimation.value,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _checkNisn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child:
                                        _isLoading
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                            : const Text('PERIKSA HASIL'),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Catatan: Pastikan NISN yang dimasukkan sudah benar',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
