# Dokumen Kebutuhan Data: Toko Daring 071

## 1. Proses Bisnis Utama
Terdapat minimal empat proses bisnis utama yang berjalan pada sistem Toko Daring Nusantara:
1. **Pendaftaran dan Manajemen Akun Pelanggan**: Proses pelanggan mendaftar akun, memperbarui profil pribadi, serta mengelola preferensi.
2. **Pengelolaan Katalog Produk**: Proses admin toko menambahkan, mengedit, menghapus, atau mengatur stok produk dan kategorinya.
3. **Pemrosesan Pesanan (Checkout)**: Proses pelanggan memilih produk, menentukan kuantitas, memasukkan alamat tujuan, menghitung total beserta ongkos kirim, dan membuat pesanan.
4. **Pembayaran dan Pengiriman**: Proses validasi pembayaran pesanan pelanggan (berhasil/gagal) dilanjutkan dengan pembuatan resi pengiriman dan pemantauan status pesanan hingga diterima oleh pelanggan.

## 2. Kebutuhan Informasi
Manajemen dan operasional membutuhkan informasi berikut untuk mengambil keputusan:
1. Daftar produk dengan penjualan tertinggi (paling laris) dalam periode tertentu.
2. Total pendapatan kotor harian, mingguan, dan bulanan dari pesanan yang sukses.
3. Riwayat status pesanan setiap pelanggan secara akurat (Pending, Dibayar, Dikirim, Selesai).
4. Pemantauan stok produk yang hampir habis (kritis) untuk restock ulang.
5. Laporan biaya logistik (ongkos kirim) beserta rasio pesanan per wilayah pengiriman.

## 3. Entitas Kandidat & Aturan Bisnis

### Entitas Kandidat
1. **Pelanggan**: Menyimpan profil pelanggan.
2. **Kategori**: Mengelompokkan produk berdasarkan jenis.
3. **Produk**: Menyimpan data master barang yang dijual.
4. **Pesanan**: Mencatat kerangka utama transaksi yang dilakukan pelanggan.
5. **Detail_Pesanan**: Mencatat item spesifik (produk) dalam satu pesanan.
6. **Pembayaran**: Mencatat transaksi pembayaran dari suatu pesanan.
7. **Pengiriman**: Mencatat informasi logistik dan nomor resi.

### Aturan Bisnis
1. Satu **Pelanggan** dapat membuat banyak **Pesanan**, namun satu **Pesanan** hanya bisa dimiliki oleh satu **Pelanggan**.
2. Satu **Pesanan** harus memiliki sekurang-kurangnya satu **Detail_Pesanan**, dan satu **Detail_Pesanan** hanya terkait dengan satu **Pesanan**.
3. Satu **Produk** dapat masuk ke banyak **Detail_Pesanan**, namun satu **Detail_Pesanan** hanya merujuk pada satu **Produk**.
4. Satu **Kategori** dapat memiliki banyak **Produk**, dan setiap **Produk** wajib memiliki satu **Kategori** utama.
5. *(Krusial)* **Harga_Satuan**, **Ongkos_Kirim**, dan **Alamat_Pengiriman** harus dicatat pada entitas transaksi (**Detail_Pesanan** dan **Pesanan**), BUKAN mengambil langsung dari master **Produk** atau **Pelanggan** saat ini, untuk menjaga riwayat data transaksi yang sah jika harga/alamat berubah di masa depan.
6. Setiap **Pesanan** maksimal hanya memiliki satu entri **Pembayaran** yang berstatus berhasil.
7. Setiap **Pesanan** yang berstatus 'Dikirim' wajib berelasi dengan tepat satu entri **Pengiriman**.
8. Stok **Produk** akan otomatis berkurang hanya jika status **Pembayaran** disahkan ('Lunas').

## 4. Matriks CRUD

Berikut adalah matriks wewenang akses fungsi Create (C), Read (R), Update (U), dan Delete (D) terhadap entitas berdasarkan aktor:

| Entitas | Admin Toko | Pelanggan | Sistem Internal (Otomasi) |
| :--- | :--- | :--- | :--- |
| **Pelanggan** | R | C, R, U | - |
| **Kategori** | C, R, U, D | R | - |
| **Produk** | C, R, U, D | R | U (Update Stok) |
| **Pesanan** | R, U | C, R | U (Update Status) |
| **Detail_Pesanan** | R | C, R | - |
| **Pembayaran** | R | C, R | R, U (Validasi) |
| **Pengiriman** | C, R, U | R | - |

*(Semua entitas memiliki fungsi Create. Pelanggan membuat entitas transaksional (Pesanan, Detail, Pembayaran), Admin membuat entitas master (Produk, Kategori, Pengiriman)).*

## 5. Kamus Data Awal

| No | Nama Elemen | Entitas | Tipe Data | Deskripsi | Penanggung Jawab (PIC) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `ID_Pelanggan` | Pelanggan | VARCHAR(10) | ID Unik pelanggan (PK) | Tim Backend |
| 2 | `Nama_Lengkap` | Pelanggan | VARCHAR(100) | Nama lengkap pelanggan | Admin Akun |
| 3 | `Email` | Pelanggan | VARCHAR(100) | Email login dan notifikasi | Tim Keamanan |
| 4 | `No_Telepon` | Pelanggan | VARCHAR(15) | Nomor HP aktif (WhatsApp) | Tim CS |
| 5 | `ID_Kategori` | Kategori | VARCHAR(5) | ID Unik Kategori (PK) | Admin Toko |
| 6 | `Nama_Kategori` | Kategori | VARCHAR(50) | Nama label kategori produk | Admin Toko |
| 7 | `ID_Produk` | Produk | VARCHAR(10) | ID Unik Produk (PK) | Admin Toko |
| 8 | `ID_Kategori` | Produk | VARCHAR(5) | Referensi ke tabel Kategori (FK) | Admin Toko |
| 9 | `Nama_Produk` | Produk | VARCHAR(150) | Nama barang jualan | Admin Toko |
| 10 | `Harga_Aktif` | Produk | DECIMAL | Harga produk saat ini | Admin Toko |
| 11 | `Stok_Tersedia` | Produk | INT | Jumlah fisik barang di gudang | Tim Gudang |
| 12 | `ID_Pesanan` | Pesanan | VARCHAR(15) | ID Unik Transaksi/Invoice (PK) | Tim Order |
| 13 | `ID_Pelanggan` | Pesanan | VARCHAR(10) | Referensi pembeli (FK) | Tim Order |
| 14 | `Waktu_Pesan` | Pesanan | DATETIME | Timestamp pembuatan pesanan | Tim Sistem |
| 15 | `Alamat_Kirim` | Pesanan | TEXT | Alamat statis saat checkout | Tim Logistik |
| 16 | `Ongkos_Kirim` | Pesanan | DECIMAL | Tarif logistik saat checkout | Tim Sistem |
| 17 | `ID_Detail` | Detail_Pesanan | VARCHAR(15) | ID Unik baris item (PK) | Tim Order |
| 18 | `ID_Pesanan` | Detail_Pesanan | VARCHAR(15) | Referensi ke header pesanan (FK)| Tim Order |
| 19 | `ID_Produk` | Detail_Pesanan | VARCHAR(10) | Referensi barang yang dibeli (FK)| Tim Order |
| 20 | `Kuantitas` | Detail_Pesanan | INT | Jumlah barang dibeli per baris | Tim Order |
| 21 | `Harga_Beli` | Detail_Pesanan | DECIMAL | Harga terkunci saat order dibuat | Tim Order |
| 22 | `Metode_Bayar` | Pembayaran | VARCHAR(50) | E-Wallet/Transfer/CC | Tim Keuangan |

## 6. Kebutuhan Non-Fungsional
1. **Keamanan (Security)**: Semua sandi pelanggan dienkripsi menggunakan algoritma bcrypt (One-way hashing). Jalur komunikasi wajib menggunakan HTTPS/SSL.
2. **Privasi dan Akses Data Pribadi (PII)**:
    * *Identifikasi Data*: `Nama_Lengkap`, `Email`, `No_Telepon`, dan `Alamat_Kirim` masuk dalam kategori Data Pribadi Sensitif.
    * *Hak Akses*: 
      - **Pelanggan** hanya boleh melihat datanya sendiri (Strict row-level security).
      - **Admin Toko/Customer Service** dilarang melihat *password*, serta `No_Telepon` akan di-*masking* sebagian (contoh: 0812345***) kecuali atas izin verifikasi.
      - **Tim Logistik/Gudang** hanya mendapatkan `Nama_Lengkap` dan `Alamat_Kirim` tanpa mengetahui `Email`.
3. **Ketersediaan (Availability)**: Sistem harus memiliki uptime minimal 99% agar proses checkout dan update keranjang tidak terganggu saat promo diskon bergulir.

---

## 7. Analisis Dokumen Sumber Fiktif

### Dokumen Sumber: Halaman Bukti Pembayaran / Invoice Pesanan

```text
======================================================
              TOKO DARING NUSANTARA
======================================================
INVOICE PESANAN
Nomor Pesanan  : INV-20231015-001
Tanggal        : 15 Okt 2023, 14:30 WIB
Pembeli        : Budi Santoso
Email          : budi.s@email.com

TUJUAN PENGIRIMAN:
Budi Santoso (0819-999-8888)
Jl. Merdeka No.45, RT 01/RW 02, Kec. Sukamaju, 
Jakarta Selatan 12345

RINCIAN PESANAN:
------------------------------------------------------
1. Kopi Arabika 250gr (Kategori: Minuman)
   2 x Rp 55.000                = Rp 110.000
2. Filter Kopi V60 (Kategori: Aksesoris)
   1 x Rp 20.000                = Rp  20.000
------------------------------------------------------
Subtotal Produk                 = Rp 130.000
Ongkos Kirim (Reguler)          = Rp  15.000
------------------------------------------------------
TOTAL PEMBAYARAN                = Rp 145.000
======================================================
Status Pembayaran : LUNAS (QRIS)
Resi Pengiriman   : JNE-999888777123
======================================================