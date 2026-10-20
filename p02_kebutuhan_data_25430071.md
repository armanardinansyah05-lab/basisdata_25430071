# Dokumen Kebutuhan Data Toko Daring (toko_071)

## 1. Latar Belakang dan Aktivitas Organisasi
Toko Daring Serba Ada 071 (`toko_071`) adalah platform e-commerce yang melayani transaksi penjualan produk secara online. Aktivitas organisasi meliputi pendaftaran pelanggan, pengelolaan katalog produk, pemrosesan pesanan, pembayaran digital, hingga pengiriman barang melalui kurir ekspedisi.

---

## 2. Parameter Personal Berbasis NIM
* **NIM**: `25430071` (Dua digit terakhir = `71`)
* **Perhitungan Parameter $P$**:
  $$P = (71 \pmod 9) + 1 = 8 + 1 = 9$$
* **Batas Maksimal Item per Transaksi Pesanan ($P + 2$)**: `11` item.
* **Persentase Diskon Promo Pelanggan ($P\%$)**: `9%`.
* **Perkiraan Volume Transaksi Pesanan Harian ($40 + 5 \times P$)**: $40 + (5 \times 9) = \mathbf{85}$ pesanan/hari.

---

## 3. Aktor dan Proses Bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| **PB-01** | Registrasi Pelanggan | Pelanggan | Pelanggan membuat akun baru |
| **PB-02** | Pengelolaan Katalog Produk | Admin | Penambahan/pembaruan produk baru |
| **PB-03** | Pemrosesan Pesanan | Pelanggan & System | Pelanggan melakukan *checkout* keranjang |
| **PB-04** | Pengiriman Barang | Kurir & Admin | Pembayaran terverifikasi oleh sistem |
| **PB-05** | Penyusunan Laporan Penjualan | Pemilik Toko | Periode bulanan berakhir |

---

## 4. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis adalah **Invoice Pesanan Online** yang memuat:
* **Identitas Pesanan**: Nomor Invoice (`INV/2026/071/001`), tanggal-jam pesanan.
* **Data Pembeli & Pengiriman**: ID Pelanggan, nama penerima, alamat pengiriman, nomor HP, dan ID kurir.
* **Rincian Produk**: ID Produk, nama produk, `qty`, harga produk saat *checkout*.
* **Nilai Turunan (Dihitung)**: Subtotal, diskon voucher 9%, ongkos kirim, dan total biaya pembayaran.

---

## 5. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Elemen Data Utama | Sumber Data |
|---|---|---|
| **Pelanggan** | `id_pelanggan`, `email_pelanggan`, `nama_pelanggan`, `no_hp_pelanggan`, `alamat_pelanggan` | Formulir registrasi |
| **Produk** | `id_produk`, `kode_produk`, `nama_produk`, `kategori_produk`, `harga_produk`, `stok_produk` | Katalog admin |
| **Pesanan** | `id_pesanan`, `no_invoice`, `tgl_pesanan`, `id_pelanggan`, `id_kurir`, `total_bayar` | Invoice pesanan |
| **Detail Pesanan** | `id_pesanan`, `id_produk`, `qty_detail_pesanan`, `harga_satuan_detail_pesanan` | Rincian checkout |
| **Kurir** | `id_kurir`, `nama_kurir`, `layanan_kurir`, `tarif_per_kg` | Master ekspedisi |
| **Pembayaran** | `id_pembayaran`, `id_pesanan`, `metode_pembayaran`, `tgl_pembayaran`, `status_pembayaran` | Gateway pembayaran |

---

## 6. Aturan Bisnis

| Kode | Aturan Bisnis |
|---|---|
| **AB-01** | Setiap pesanan menghasilkan nomor invoice unik dan maksimal memuat **11** jenis item produk yang berbeda. |
| **AB-02** | Pelanggan terverifikasi berhak mendapatkan diskon promo sebesar **9%** dari total harga belanja produk. |
| **AB-03** | Stok produk tidak boleh negatif. Pesanan akan dibatalkan otomatis oleh sistem jika `qty` melebihi stok tersedia. |
| **AB-04** | Harga satuan produk pada detail pesanan dicatat berdasarkan harga pada saat *checkout* dan tidak berubah jika harga master produk diperbarui. |
| **AB-05** | Email pelanggan bersifat unik dan digunakan sebagai kredensial utama untuk *login*. |
| **AB-06** | Pesanan baru akan diproses pengirimannya hanya jika status pembayaran berstatus `LUNAS`. |
| **AB-07** | Setiap transaksi pengiriman barang wajib mencantumkan ID kurir dan alamat lengkap penerima. |
| **AB-08** | Satu pelanggan dapat melakukan transaksi pesanan lebih dari satu kali (*one-to-many*). |

---

## 7. Kebutuhan Informasi

| Kode | Kebutuhan Informasi | Data yang Diperlukan |
|---|---|---|
| **KI-01** | Laporan total omzet harian dan bulanan toko | Pesanan, Detail Pesanan |
| **KI-02** | Laporan 5 produk terlaris berdasarkan kuantitas penjualan bulanan | Detail Pesanan, Produk |
| **KI-03** | Laporan daftar produk yang stoknya habis atau kurang dari 5 unit | Produk |
| **KI-04** | Laporan 10 pelanggan dengan akumulasi belanja terbanyak | Pesanan, Detail Pesanan, Pelanggan |
| **KI-05** | Laporan rekapitulasi jumlah pengiriman berdasarkan jasa kurir | Pesanan, Kurir |

---

## 8. Matriks CRUD

| Proses Bisnis | Pelanggan | Produk | Pesanan | Detail Pesanan | Kurir | Pembayaran |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **PB-01**: Registrasi Pelanggan | **C** | - | - | - | - | - |
| **PB-02**: Pengelolaan Katalog | - | **C, U, D**| - | - | - | - |
| **PB-03**: Pemrosesan Pesanan | **R** | **R, U** | **C** | **C** | **R** | **C** |
| **PB-04**: Pengiriman Barang | - | - | **U** | **R** | **R** | **R, U** |
| **PB-05**: Penyusunan Laporan | **R** | **R** | **R** | **R** | **R** | **R** |

---

## 9. Kamus Data Awal

| Elemen Data | Arti | Contoh | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|
| `id_pelanggan` | Identifier unik pelanggan | `101` | Integer, Primary Key | Admin |
| `email_pelanggan` | Alamat email terdaftar | `user@email.com` | Unik, Format email valid | Admin |
| `nama_pelanggan` | Nama lengkap pelanggan | `Arman Ardinansyah` | Teks, Tidak boleh NULL | Admin |
| `no_hp_pelanggan` | Nomor telepon pelanggan | `08123456789` | Data Pribadi, 10-13 digit | Admin |
| `alamat_pelanggan` | Alamat pengiriman utama | `Jl. Mawar No. 12` | Data Pribadi, Teks | Admin |
| `id_produk` | Identifier unik produk | `501` | Integer, Primary Key | Product Manager |
| `kode_produk` | Kode sku barang | `PRD-071-01` | Unik, String | Product Manager |
| `nama_produk` | Nama produk barang | `Mouse Wireless` | Teks, Tidak boleh NULL | Product Manager |
| `harga_produk` | Harga jual per unit | `150000` | Decimal $\ge 0$ | Product Manager |
| `stok_produk` | Jumlah stok tersedia | `50` | Integer $\ge 0$ (AB-03) | Product Manager |
| `id_pesanan` | Identifier unik pesanan | `1001` | Integer, Primary Key | System |
| `no_invoice` | Nomor resmi invoice | `INV/2026/071/001`| Unik, String | System |
| `tgl_pesanan` | Waktu transaksi pesanan | `2026-10-20 09:00` | Datetime | System |
| `qty_detail_pesanan` | Jumlah produk dibeli | `2` | Integer, Max 11 (AB-01) | System |
| `harga_satuan_detail_pesanan` | Harga produk saat checkout| `150000` | Decimal $\ge 0$ (AB-04) | System |
| `id_kurir` | Identifier pengiriman kurir | `1` | Foreign Key | Operasional |
| `nama_kurir` | Nama jasa kurir | `JNE Express` | String | Operasional |
| `id_pembayaran` | Identifier transaksi bayar | `801` | Integer, Primary Key | Finance |
| `metode_pembayaran` | Jenis pembayaran digital | `Transfer Bank` | Enum | Finance |
| `status_pembayaran` | Status verifikasi dana | `LUNAS` | Enum (`PENDING`, `LUNAS`) | Finance |

---

## 10. Kebutuhan Non-Fungsional Data
* **Volume Transaksi**: Sistem dirancang untuk mengolah perkiraan **85** pesanan per hari.
* **Retensi Data**: Riwayat pesanan dan invoice disimpan dalam basis data aktif selama 5 tahun.
* **Pelindungan Data Pribadi (PDP)**: Atribut `no_hp_pelanggan` dan `alamat_pelanggan` dikategorikan sebagai data pribadi sensitif yang tidak boleh diakses oleh pihak luar atau kurir secara utuh tanpa terenkripsi/terkonfirmasi.

---

## 11. Isu Kualitas Data yang Diantisipasi
* Penulisan alamat pengiriman pelanggan yang tidak lengkap atau tidak terstruktur.
* Pengisian nomor telepon dengan karakter non-angka atau kombinasi kode negara (`+62`) yang tidak seragam.