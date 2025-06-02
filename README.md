# DynamicTSP

🚀 **Traveling Salesman Problem Solver menggunakan Dynamic Programming dengan Bitmask**

Implementasi efisien untuk menyelesaikan TSP menggunakan algoritma Dynamic Programming dengan teknik bitmask dan memoization. Ditulis dalam Swift dengan interface CLI yang user-friendly.

## 📋 Daftar Isi

- [Tentang Proyek](#tentang-proyek)
- [Fitur](#fitur)
- [Algoritma](#algoritma)
- [Instalasi](#instalasi)
- [Cara Penggunaan](#cara-penggunaan)
- [Contoh Penggunaan](#contoh-penggunaan)
- [Kompleksitas](#kompleksitas)
- [Struktur Proyek](#struktur-proyek)
- [Lisensi](#lisensi)

## 🎯 Tentang Proyek

**Traveling Salesman Problem (TSP)** adalah salah satu masalah optimisasi klasik dalam computer science. Proyek ini mengimplementasikan solusi optimal menggunakan Dynamic Programming dengan bitmask untuk mencari jalur terpendek yang mengunjungi semua kota tepat satu kali dan kembali ke kota asal.

**Dibuat oleh:** Kenneth Poenadi (13523040)

## ✨ Fitur

- 🔄 **Dynamic Programming dengan Bitmask** - Algoritma optimal untuk TSP
- 💾 **Memoization** - Menghindari perhitungan berulang
- 📊 **Input Manual** - Interface interaktif untuk memasukkan matriks jarak
- 📈 **Visualisasi Matriks** - Tampilan matriks jarak yang rapi
- ⚡ **Analisis Performa** - Waktu komputasi dan kompleksitas
- 🛡️ **Validasi Input** - Pengecekan input yang robust
- 📚 **Panduan Bantuan** - Tutorial lengkap dalam aplikasi
- 🎨 **Interface CLI Menarik** - Tampilan yang clean dan profesional

## 🧮 Algoritma

### Cara Kerja

1. **Representasi State**: Menggunakan bitmask untuk merepresentasikan subset kota yang sudah dikunjungi
2. **Fungsi Rekursif**: `tsp(mask, currentCity)` mengembalikan biaya minimum untuk mengunjungi semua kota dalam mask dan berakhir di currentCity
3. **Base Case**: Semua kota sudah dikunjungi → kembali ke kota awal
4. **Memoization**: Menyimpan hasil perhitungan untuk menghindari redundansi
5. **Path Reconstruction**: Merekonstruksi jalur optimal dari tabel memoization

### Pseudocode

```
function tsp(mask, currentCity):
    if mask == (1 << n) - 1:  // semua kota dikunjungi
        return distance[currentCity][0]
    
    if memo[mask][currentCity] != -1:
        return memo[mask][currentCity]
    
    result = INF
    for nextCity in 0..n-1:
        if nextCity not in mask:
            newMask = mask | (1 << nextCity)
            cost = distance[currentCity][nextCity] + tsp(newMask, nextCity)
            result = min(result, cost)
    
    memo[mask][currentCity] = result
    return result
```

## 🚀 Instalasi

### Prasyarat

- **Swift 5.0+** (Xcode 11+ atau Swift di Linux/Windows/MacOS)
- **Terminal/Command Line Interface**

### Langkah Instalasi

1. **Clone Repository**
   ```bash
   git clone https://github.com/KennethhPoenadi/DynamicTSP.git
   cd DynamicTSP
   ```

2. **Verifikasi Swift Installation**
   ```bash
   swift --version
   ```

3. **Jalankan Program**
   ```bash
   swift DynamicTSP.swift
   ```

## 💻 Cara Penggunaan

### Menjalankan Program

```bash
swift DynamicTSP.swift
```

### Menu Utama

Program menyediakan 3 opsi utama:

1. **Input Manual** - Masukkan matriks jarak sendiri
2. **Bantuan** - Panduan lengkap penggunaan
3. **Keluar** - Menutup program

### Input Manual

1. Masukkan jumlah kota (2-20)
2. Input matriks jarak kota secara berurutan
3. Program akan menampilkan:
   - Matriks jarak yang dimasukkan
   - Jalur optimal
   - Total jarak minimum
   - Waktu komputasi

## 📖 Contoh Penggunaan

### Contoh 1: Graf Simetris 4 Kota

```
masukkan jumlah kota (2-20): 4

masukkan matriks jarak 4×4:
   jarak kota 0 → kota 1: 10
   jarak kota 0 → kota 2: 15
   jarak kota 0 → kota 3: 20
   jarak kota 1 → kota 2: 35
   jarak kota 1 → kota 3: 25
   jarak kota 2 → kota 3: 30
```

**Output:**
```
=== matriks jarak yang dimasukkan ===
    0       1       2       3
0:  0       10      15      20
1:  10      0       35      25
2:  15      35      0       30
3:  20      25      30      0

┌────────────────────────────────────────┐
│              HASIL OPTIMAL             │
├────────────────────────────────────────┤
│ jalur: kota 0 → kota 1 → kota 3 → kota 2 → kota 0
│ total jarak: 80
└────────────────────────────────────────┘

waktu komputasi: 0.002 detik
```

### Contoh 2: Graf Asimetris

```
Input:
0  5  10  15
6  0   8  12
14 7   0   9
11 13  4   0

Output:
jalur: kota 0 → kota 1 → kota 2 → kota 3 → kota 0
total jarak: 28
```

## ⚡ Kompleksitas

| Metrik | Kompleksitas |
|--------|--------------|
| **Waktu** | O(n² × 2ⁿ) |
| **Ruang** | O(n × 2ⁿ) |
| **Optimal untuk** | n ≤ 15 kota |

### Perbandingan dengan Algoritma Lain

| Algoritma | Kompleksitas Waktu | Optimal? |
|-----------|-------------------|----------|
| Brute Force | O(n!) | ✅ Ya |
| **Dynamic Programming** | **O(n² × 2ⁿ)** | **✅ Ya** |
| Nearest Neighbor | O(n²) | ❌ Tidak |
| Genetic Algorithm | O(generasi × populasi × n) | ❌ Heuristik |

## 📁 Struktur Proyek

```
DynamicTSP/
├── DynamicTSP.swift      # File utama dengan implementasi algoritma
├── README.md             # Dokumentasi proyek
├── LICENSE.txt           # Lisensi Apache 2.0
├── .swift-version        # Versi Swift yang digunakan
└── TSPTests.swift        # File testing (opsional)
```

### Komponen Kode

- **`TSPSolver`** - Class utama implementasi algoritma
- **`printMatrix()`** - Fungsi untuk menampilkan matriks
- **`printPath()`** - Fungsi untuk menampilkan hasil
- **`getInputFromUser()`** - Fungsi input manual
- **`showHelp()`** - Fungsi bantuan
- **`main()`** - Fungsi utama program

## 📝 Lisensi

Proyek ini dilisensikan under **Apache License 2.0**. Lihat file [LICENSE.txt](LICENSE.txt) untuk detail lengkap.

## 📚 Referensi

- [Traveling Salesman Problem - Wikipedia](https://en.wikipedia.org/wiki/Travelling_salesman_problem)
- [Dynamic Programming Approach to TSP](https://www.geeksforgeeks.org/travelling-salesman-problem-set-1/)
- [Bitmask DP Tutorial](https://www.hackerearth.com/practice/algorithms/dynamic-programming/bit-masking/tutorial/)

## 📞 Kontak

**Kenneth Poenadi**
- Email: 13523040@std.stei.itb.ac.id
- NIM: 13523040

---