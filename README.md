# 💰 Aplikasi Keuangan Pribadi

Aplikasi manajemen keuangan pribadi modern yang dibangun dengan Flutter, menampilkan UI/UX yang elegan dengan Material Design 3, dark mode, dan animasi yang halus.

![Flutter](https://img.shields.io/badge/Flutter-3.10.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Fitur Utama

### 🔐 Keamanan
- **Autentikasi Biometrik** - Login dengan fingerprint atau face ID
- **Penyimpanan Aman** - Data sensitif dienkripsi dengan Flutter Secure Storage

### 📊 Dashboard & Visualisasi
- **Dashboard Interaktif** - Ringkasan keuangan dengan grafik real-time
- **Grafik & Chart** - Visualisasi pengeluaran dan pemasukan dengan FL Chart
- **Laporan Keuangan** - Analisis detail transaksi dan tren keuangan

### 💸 Manajemen Transaksi
- **Pencatatan Transaksi** - Catat pemasukan dan pengeluaran dengan mudah
- **Kategori Custom** - Buat dan kelola kategori transaksi sendiri
- **Riwayat Lengkap** - Lihat semua transaksi dengan filter dan pencarian

### 🎯 Budgeting
- **Buat Budget** - Tetapkan anggaran untuk setiap kategori
- **Notifikasi Alert** - Peringatan ketika mendekati atau melebihi budget
- **Tracking Progress** - Monitor penggunaan budget secara real-time

### 💱 Konverter Mata Uang
- **Multi-Currency** - Konversi antar berbagai mata uang
- **Update Real-time** - Kurs mata uang yang selalu terkini

### 🎨 UI/UX Modern
- **Material Design 3** - Desain modern mengikuti standar terbaru
- **Dark Mode** - Mode gelap untuk kenyamanan mata
- **Animasi Halus** - Transisi dan animasi yang smooth dengan Flutter Animate
- **Responsive** - Tampilan optimal di berbagai ukuran layar

## 🛠️ Teknologi

### Framework & Language
- **Flutter** ^3.10.4
- **Dart** ^3.10.4

### State Management
- **Riverpod** ^2.5.1 - State management yang powerful dan type-safe

### Database & Storage
- **Hive** ^2.2.3 - Database lokal yang cepat dan ringan
- **Flutter Secure Storage** ^9.2.2 - Penyimpanan data sensitif yang aman

### UI & Visualization
- **FL Chart** ^0.69.0 - Library charting yang fleksibel
- **Flutter Animate** ^4.5.0 - Animasi yang mudah dan powerful
- **Flutter SVG** ^2.0.10 - Support untuk icon dan gambar SVG

### Utilities
- **Go Router** ^14.6.2 - Navigasi yang declarative
- **Intl** ^0.19.0 - Formatting tanggal dan mata uang
- **UUID** ^4.5.1 - Generator ID unik
- **Local Auth** ^2.3.0 - Autentikasi biometrik

## 📁 Struktur Projekt

```
lib/
├── core/                      # Core functionality
│   ├── constants/            # App constants (colors, themes)
│   ├── services/             # Services (biometric, storage, currency)
│   └── utils/                # Utilities (formatters)
├── data/                      # Data layer
│   └── models/               # Data models (transaction, budget, settings)
├── features/                  # Feature modules
│   ├── dashboard/            # Dashboard screen
│   ├── transactions/         # Transaction management
│   ├── reports/              # Financial reports
│   ├── converter/            # Currency converter
│   ├── settings/             # App settings
│   └── onboarding/           # Onboarding flow
├── providers/                 # Riverpod providers
│   ├── transaction_provider.dart
│   ├── budget_provider.dart
│   └── settings_provider.dart
└── main.dart                  # App entry point
```

## 🚀 Instalasi

### Prerequisites
- Flutter SDK (^3.10.4)
- Dart SDK (^3.10.4)
- Android Studio / VS Code
- Android SDK / Xcode (untuk iOS)

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd aplikasi_keuangan
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📱 Penggunaan

### Setup Awal
1. Buka aplikasi dan ikuti proses onboarding
2. Setup autentikasi biometrik (opsional)
3. Konfigurasi preferensi mata uang dan kategori

### Menambah Transaksi
1. Tap tombol **+** di dashboard
2. Pilih jenis transaksi (Pemasukan/Pengeluaran)
3. Isi detail transaksi (jumlah, kategori, catatan)
4. Simpan transaksi

### Membuat Budget
1. Buka menu **Budget**
2. Tap **Buat Budget Baru**
3. Pilih kategori dan tentukan limit
4. Set periode budget (bulanan/tahunan)

### Melihat Laporan
1. Buka menu **Laporan**
2. Pilih periode yang ingin dilihat
3. Analisis grafik dan statistik keuangan

## 🎨 Kustomisasi

### Mengubah Tema
Edit file `lib/core/constants/app_theme.dart` untuk menyesuaikan warna dan tema aplikasi.

### Menambah Kategori
Kategori dapat ditambahkan melalui menu Settings atau langsung saat membuat transaksi.

## 🔧 Development

### Running Tests
```bash
flutter test
```

### Build APK
```bash
flutter build apk --release
```

### Build iOS
```bash
flutter build ios --release
```

## 📝 Roadmap

- [ ] Sinkronisasi cloud
- [ ] Export data ke CSV/PDF
- [ ] Reminder untuk pembayaran rutin
- [ ] Multi-akun support
- [ ] Widget untuk home screen
- [ ] Integrasi dengan bank (Open Banking)

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan buat pull request atau buka issue untuk saran dan bug report.

## 📄 License

Project ini dilisensikan under MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter

---

**Note**: Aplikasi ini masih dalam tahap pengembangan. Fitur-fitur baru akan terus ditambahkan.
