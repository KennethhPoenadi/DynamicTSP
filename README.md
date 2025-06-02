# DynamicTSP

 **Traveling Salesman Problem Solver menggunakan Dynamic Programming dengan f(i,S)**

Implementasi TSP menggunakan algoritma Dynamic Programming dari Persoalan 4 dengan notasi f(i,S) = min{c_ij + f(j, S-{j})}. Ditulis dalam Swift dengan interface CLI yang user-friendly dan tampilan tahapan perhitungan yang detail.

##  Daftar Isi

- [Tentang Proyek](#tentang-proyek)
- [Fitur](#fitur)
- [Algoritma](#algoritma)
- [Instalasi](#instalasi)
- [Cara Penggunaan](#cara-penggunaan)
- [Contoh Penggunaan](#contoh-penggunaan)
- [Kompleksitas](#kompleksitas)
- [Struktur Proyek](#struktur-proyek)
- [Lisensi](#lisensi)

##  Tentang Proyek

**Traveling Salesman Problem (TSP)** adalah salah satu masalah optimisasi klasik dalam computer science. Proyek ini mengimplementasikan solusi optimal menggunakan algoritma Dynamic Programming dari **Persoalan 4** dengan notasi f(i,S) untuk mencari jalur terpendek yang mengunjungi semua kota tepat satu kali dan kembali ke kota asal.

**Dibuat oleh:** Kenneth Poenadi (13523040)

<p align="center">
  <img src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  <img src="https://img.shields.io/badge/Algorithm-Dynamic_Programming-blue?style=for-the-badge" alt="Dynamic Programming">
  <img src="https://img.shields.io/badge/Complexity-O(n²×2ⁿ)-red?style=for-the-badge" alt="Complexity">
</p>

##  Fitur

-  **Algoritma f(i,S)** - Implementasi exact dari Persoalan 4
-  **Memoization dengan Bitmask** - Penyimpanan state yang efisien
-  **Tampilan Tahapan Perhitungan** - Debug output untuk setiap tahap
-  **Visualisasi Matriks** - Tampilan matriks jarak yang rapi
-  **Analisis Performa** - Waktu komputasi dan tracking kompleksitas
-  **Validasi Input Robust** - Pengecekan input dengan peringatan
-  **Panduan Bantuan Lengkap** - Tutorial dan penjelasan algoritma
-  **Interface CLI Modern** - Tampilan yang clean dengan Unicode box drawing

##  Algoritma

### Implementasi Persoalan 4

Program ini mengimplementasikan algoritma TSP dengan notasi:

**f(i, S) = min{c_ij + f(j, S-{j})}** untuk j ∈ S

dengan basis: **f(i, ∅) = c_i1**

### Tahapan Algoritma

1. **Tahap 1**: Hitung basis f(i, ∅) = c_i1 untuk semua i ≠ 1
2. **Tahap 2-n**: Hitung f(i, S) untuk |S| = 1, 2, ..., n-2
3. **Tahap Akhir**: Hitung f(1, V-{1}) = tur terpendek
4. **Rekonstruksi**: Gunakan choice table J(i,S) untuk mendapatkan jalur optimal

### Pseudocode

```
function computeF(i, S):
    if S is empty:
        return c_i1
    
    if memo[i][S] exists:
        return memo[i][S]
    
    minCost = INF
    bestChoice = -1
    
    for j in S:
        newS = S - {j}
        cost = c_ij + computeF(j, newS)
        if cost < minCost:
            minCost = cost
            bestChoice = j
    
    memo[i][S] = minCost
    choice[i][S] = bestChoice
    return minCost
```

##  Instalasi

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

##  Cara Penggunaan

### Menjalankan Program

```bash
swift DynamicTSP.swift
```

### Menu Utama

Program menyediakan 3 opsi utama:

1. **Input Manual** - Masukkan matriks jarak sendiri
2. **Bantuan** - Panduan lengkap penggunaan dan penjelasan algoritma
3. **Keluar** - Menutup program

### Input Manual

1. Masukkan jumlah kota (2-15)
2. Input matriks jarak kota secara berurutan
3. Program akan menampilkan:
   - Matriks jarak yang dimasukkan
   - Detail tahapan perhitungan f(i,S)
   - Jalur optimal dengan choice table
   - Total jarak minimum
   - Waktu komputasi

### Peringatan Performa

- **n ≤ 10**: Performa optimal, hasil instan
- **n > 10**: Akan muncul peringatan karena kompleksitas eksponensial
- **n > 15**: Tidak disarankan untuk penggunaan interaktif

##  Contoh Penggunaan

### Contoh: Graf 4 Kota

**Input:**
```
masukkan jumlah kota (2-15): 4

masukkan matriks jarak 4×4:
   jarak kota 1 → kota 2: 10
   jarak kota 1 → kota 3: 15
   jarak kota 1 → kota 4: 20
   jarak kota 2 → kota 1: 5
   jarak kota 2 → kota 3: 9
   jarak kota 2 → kota 4: 10
   ... (dst)
```

**Output:**
```
=== matriks jarak yang dimasukkan ===
    kota1   kota2   kota3   kota4   
kota1:0       10      15      20      
kota2:5       0       9       10      
kota3:6       13      0       12      
kota4:8       20      15      0       

 TAHAPAN PERHITUNGAN TSP:
==================================================

TAHAP 1 - BASIS f(i, ∅):
f(2, ∅) = c_{2,1} = 5
f(3, ∅) = c_{3,1} = 6
f(4, ∅) = c_{4,1} = 8

TAHAP 2 - SUBSET UKURAN 1:
f(2, {3}) = 15, pilih kota 3
f(2, {4}) = 18, pilih kota 4
f(3, {2}) = 18, pilih kota 2
f(3, {4}) = 20, pilih kota 4
f(4, {2}) = 13, pilih kota 2
f(4, {3}) = 15, pilih kota 3

TAHAP 3 - SUBSET UKURAN 2:
f(2, {3,4}) = 25, pilih kota 4
f(3, {2,4}) = 25, pilih kota 4
f(4, {2,3}) = 23, pilih kota 3

HASIL AKHIR:
f(1, {2,3,4}) = 35, pilih kota 2
==================================================

┌──────────────────────────────────────────────────┐
│                HASIL OPTIMAL                     │
├──────────────────────────────────────────────────┤
│ jalur: kota 1 → kota 2 → kota 4 → kota 3 → kota 1
│ total jarak: 35
└──────────────────────────────────────────────────┘

waktu komputasi: 0.003 detik
```

##  Kompleksitas

| Metrik | Kompleksitas |
|--------|--------------|
| **Waktu** | O(n² × 2ⁿ) |
| **Ruang** | O(n × 2ⁿ) |
| **Subset yang dihitung** | 2ⁿ⁻¹ |
| **Optimal untuk** | n ≤ 15 kota |

### Perbandingan dengan Algoritma Lain

| Algoritma | Kompleksitas Waktu | Optimal? | Keterangan |
|-----------|-------------------|----------|------------|
| Brute Force | O(n!) | ✅ Ya | Sangat lambat untuk n > 10 |
| **f(i,S) Dynamic Programming** | **O(n² × 2ⁿ)** | **✅ Ya** | **Implementasi ini** |
| Held-Karp DP | O(n² × 2ⁿ) | ✅ Ya | Variasi dengan bitmask |
| Nearest Neighbor | O(n²) | ❌ Tidak | Heuristik cepat |
| Genetic Algorithm | O(generasi × populasi × n) | ❌ Tidak | Metaheuristik |

### Estimasi Waktu Eksekusi

| Jumlah Kota (n) | Subset (2ⁿ) | Estimasi Waktu |
|----------------|-------------|----------------|
| 5 | 32 | < 0.001s |
| 8 | 256 | < 0.01s |
| 10 | 1,024 | < 0.1s |
| 12 | 4,096 | < 0.5s |
| 15 | 32,768 | 1-5s |
| 20 | 1,048,576 | 30s+ |

## 📁 Struktur Proyek

```
C:.
    .swift-version
    DynamicTSP.swift
    LICENSE.txt
    README.md
    swiftly-x86_64.tar.gz
    
```

### Komponen Kode Utama

| Komponen | Fungsi |
|----------|--------|
| **`TSPSolver`** | Class utama implementasi algoritma f(i,S) |
| **`computeF()`** | Fungsi rekursif untuk menghitung f(i,S) |
| **`reconstructOptimalPath()`** | Rekonstruksi jalur dari choice table |
| **`printCalculationSteps()`** | Debug output tahapan perhitungan |
| **`printMatrix()`** | Visualisasi matriks jarak |
| **`getInputFromUser()`** | Interface input manual dengan validasi |

##  Lisensi

Proyek ini dilisensikan under **Apache License 2.0**. Lihat file [LICENSE.txt](LICENSE.txt) untuk detail lengkap.

##  Kontak

**Kenneth Poenadi**
- **Email**: 13523040@std.stei.itb.ac.id
- **NIM**: 13523040

---
