# Dokumen Kebutuhan Data Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa Sejahtera (Kopma) mengelola aktivitas penjualan kebutuhan mahasiswa seperti alat tulis, makanan, dan minuman. Pencatatan transaksi selama ini dilakukan manual melalui buku tulis dan spreadsheet, yang sering mengakibatkan masalah keilangan riwayat harga lama, stok bernilai minus, serta kesulitan pencarian data anggota.

## 2. Aktor dan Proses Bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| **PB-01** | Mendaftarkan anggota | Kasir | Mahasiswa mengajukan pendaftaran anggota |
| **PB-02** | Mencatat penjualan | Kasir | Pembeli melakukan pembayaran di kasir |
| **PB-03** | Memesan barang ke pemasok | Petugas gudang | Stok barang mencapai/di bawah batas minimum |
| **PB-04** | Menerima barang dari pemasok | Petugas gudang | Barang datang beserta faktur dari pemasok |
| **PB-05** | Menyusun laporan bulanan | Ketua koperasi | Memasuki awal bulan baru |

---

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis adalah **Nota Penjualan Kopma** yang memuat elemen data:
* **Identitas Transaksi**: Nomor nota (`PJ-2609-0142`), tanggal-jam transaksi.
* **Relasi Aktor**: Kode/nama kasir, nomor/nama anggota (opsional).
* **Rincian Barang**: Kode/nama barang, kuantitas (`qty`), harga jual saat transaksi.
* **Nilai Turunan (Dihitung)**: Subtotal per baris, diskon anggota 5%, total bayar, bayar tunai, dan kembalian.

---

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Elemen Data Utama | Sumber Data |
|---|---|---|
| **Anggota** | `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`, `tgl_daftar_anggota` | Formulir pendaftaran |
| **Barang** | `kode_barang`, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang` | Katalog barang & faktur |
| **Penjualan** | `no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `id_anggota`, `bayar_penjualan` | Nota penjualan |
| **Detail Penjualan** | `no_nota_penjualan`, `kode_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan` | Nota penjualan |
| **Petugas** | `kode_petugas`, `nama_petugas`, `peran_petugas` | Data internal pengurus |
| **Pemasok** | `id_pemasok`, `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok` | Faktur pemasok |
| **Pembelian** | `no_faktur_pembelian`, `tgl_pembelian`, `id_pemasok`, `status_pembelian` | Faktur pemasok |
| **Detail Pembelian**| `no_faktur_pembelian`, `kode_barang`, `qty_detail_pembelian`, `harga_beli_detail_pembelian` | Faktur pemasok |

---

## 5. Aturan Bisnis

| Kode | Aturan Bisnis |
|---|---|
| **AB-01** | Setiap nota transaksi penjualan memiliki nomor nota unik dan wajib memuat minimal satu jenis barang. |
| **AB-02** | Penjualan dapat dilakukan kepada pembeli umum (tanpa anggota); jika pembeli adalah anggota aktif, berhak mendapatkan diskon sebesar 5%. |
| **AB-03** | Stok barang tidak boleh bernilai negatif; transaksi penjualan wajib ditolak jika `qty` melebihi stok yang tersedia. |
| **AB-04** | Harga jual yang dicatat pada detail penjualan adalah harga saat transaksi berlangsung dan bersifat permanen (tidak berubah jika harga master barang dinaikkan). |
| **AB-05** | NIM anggota bersifat unik. Pencarian data anggota di kasir dapat dilakukan menggunakan nomor anggota atau NIM. |
| **AB-06** | Pesanan pembelian ke pemasok diproses jika stok barang berada di bawah atau sama dengan batas minimum stok (`stok_min_barang`). |

---

## 6. Kebutuhan Informasi

| Kode | Kebutuhan Informasi | Data yang Diperlukan |
|---|---|---|
| **KI-01** | Laporan omzet harian dan bulanan serta total transaksi | Penjualan, Detail Penjualan |
| **KI-02** | Laporan 5 barang terlaris per bulan berdasarkan total kuantitas terjual | Detail Penjualan, Barang |
| **KI-03** | Laporan daftar barang yang stoknya di bawah batas minimum | Barang |
| **KI-04** | Laporan 10 anggota dengan total akumulasi belanja terbesar per bulan | Penjualan, Detail Penjualan, Anggota |

---

## 7. Matriks CRUD

| Proses Bisnis | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **PB-01**: Mendaftarkan anggota | **C** | - | - | - | - | - |
| **PB-02**: Mencatat penjualan | **R** | **R, U** | **C** | **C** | - | - |
| **PB-03**: Memesan barang | - | **R** | - | - | **R** | **C** |
| **PB-04**: Menerima barang | - | **U** | - | - | **R** | **U** |
| **PB-05**: Laporan bulanan | **R** | **R** | **R** | **R** | - | **R** |

---

## 8. Kamus Data Awal

| Elemen Data | Arti | Contoh | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|
| `no_anggota` | Nomor unik anggota Kopma | `A-0457` | Format `A-XXXX`, Unik | Ketua |
| `nim_anggota` | Nomor Induk Mahasiswa | `25430071` | Tepat 10 digit, Unik | Ketua |
| `no_hp_anggota` | Nomor telepon anggota | `081234567890` | Data pribadi, Boleh NULL | Ketua |
| `no_nota_penjualan` | Kode nota transaksi | `PJ-2609-0142` | Format `PJ-YYMM-NNNN`, Unik | Kasir |
| `harga_satuan_detail_penjualan` | Harga jual per unit saat transaksi | `4000` | Angka bulat $\ge 0$ | Kasir |
| `stok_barang` | Sisa persediaan barang | `35` | Angka bulat $\ge 0$ (AB-03) | Petugas Gudang |

---

## 9. Kebutuhan Non-Fungsional Data
* **Volume Transaksi**: Diperkirakan mengelola sekitar 150 nota penjualan per hari.
* **Retensi Data**: Data transaksi wajib disimpan minimal selama 5 tahun untuk audit keuangan.
* **Privasi Data**: Nomor telepon anggota bersifat rahasia dan tidak boleh diakses oleh kasir.

---

## 10. Isu Kualitas Data yang Diantisipasi
* Ejaan nama anggota atau nama pemasok yang tidak konsisten akibat pengisian manual.
* Format NIM ganda atau tidak standar saat proses pendaftaran anggota secara cepat.