# Dokumen Normalisasi Proyek Mandiri - Toko Daring

**Nama:** Arman Ardinansyah  
**NIM:** 25430071  
**Tema Proyek:** Toko Daring  

---

## 1. Dokumen Sumber Awal (Invoice Transaksi)
Dokumen sumber yang digunakan adalah Invoice Penjualan Toko Daring (`INV-20261020-001`) yang mencatat data pelanggan, pengiriman, pembayaran, serta rincian barang yang dibeli.

---

## 2. Tahapan Normalisasi

### Bentuk Tidak Ternormalisasi (UNF)
Pada bentuk UNF, seluruh atribut transaksi disimpan dalam satu struktur dengan grup berulang pada rincian produk yang dibeli:

`PESANAN_UNF (no_invoice, tgl_pesanan, email_pelanggan, nama_pelanggan, no_hp_pelanggan, alamat_pelanggan, nama_kurir, layanan_kurir, tarif_per_kg, { kode_produk, nama_produk, kategori_produk, qty_detail_pesanan, harga_satuan_detail_pesanan, subtotal_detail_pesanan }, total_bayar, metode_pembayaran, status_pembayaran)`

### Bentuk Normal Pertama (1NF)
Menghilangkan grup berulang dengan meratakan baris data sehingga setiap sel bernilai tunggal (*atomic value*). Kunci primer komposit yang ditetapkan adalah `(no_invoice, kode_produk)`:

`PESANAN_1NF (no_invoice, kode_produk, tgl_pesanan, email_pelanggan, nama_pelanggan, no_hp_pelanggan, alamat_pelanggan, nama_kurir, layanan_kurir, tarif_per_kg, nama_produk, kategori_produk, qty_detail_pesanan, harga_satuan_detail_pesanan, subtotal_detail_pesanan, total_bayar, metode_pembayaran, status_pembayaran)`

---

## 3. Daftar Dependensi Fungsional (Functional Dependencies)

* **FD1**: `no_invoice -> tgl_pesanan, email_pelanggan, nama_kurir, total_bayar` (AB-01: Invoice bersifat unik per transaksi)
* **FD2**: `email_pelanggan -> nama_pelanggan, no_hp_pelanggan, alamat_pelanggan` (AB-02: Pelanggan teridentifikasi unik lewat email)
* **FD3**: `kode_produk -> nama_produk, kategori_produk` (AB-03: Katalog produk memiliki kode unik)
* **FD4**: `nama_kurir -> layanan_kurir, tarif_per_kg` (AB-04: Ekspedisi kurir menentukan tarif pengiriman)
* **FD5**: `(no_invoice, kode_produk) -> qty_detail_pesanan, harga_satuan_detail_pesanan` (AB-05: Harga item dicatat sebagai snapshot saat transaksi)
* **FD6**: `qty_detail_pesanan, harga_satuan_detail_pesanan -> subtotal_detail_pesanan` (Nilai Turunan)
* **FD7**: `no_invoice -> metode_pembayaran, status_pembayaran` (AB-06: Setiap pesanan memiliki satu status pembayaran)

---

## 4. Bentuk Normal Kedua (2NF) dan Ketiga (3NF)

### Bentuk Normal Kedua (2NF)
Memisahkan ketergantungan parsial (*partial dependency*) dari kunci komposit:

* `PELANGGAN (email_pelanggan, nama_pelanggan, no_hp_pelanggan, alamat_pelanggan)`
* `PRODUK (kode_produk, nama_produk, kategori_produk)`
* `KURIR (nama_kurir, layanan_kurir, tarif_per_kg)`
* `PESANAN (no_invoice, tgl_pesanan, email_pelanggan*, nama_kurir*, total_bayar)`
* `DETAIL_PESANAN (no_invoice*, kode_produk*, qty_detail_pesanan, harga_satuan_detail_pesanan)`
* `PEMBAYARAN (no_invoice*, metode_pembayaran, status_pembayaran)`

### Bentuk Normal Ketiga (3NF) & Penerapan Kunci Pengganti (Surrogate Key)
Memisahkan ketergantungan transitif serta menerapkan `id_*` sebagai kunci primer tunggal:

* `PELANGGAN (id_pelanggan [PK], email_pelanggan [UQ], nama_pelanggan, no_hp_pelanggan, alamat_pelanggan)`
* `PRODUK (id_produk [PK], kode_produk [UQ], nama_produk, kategori_produk, harga_produk, stok_produk)`
* `KURIR (id_kurir [PK], nama_kurir, layanan_kurir, tarif_per_kg)`
* `PESANAN (id_pesanan [PK], no_invoice [UQ], tgl_pesanan, id_pelanggan [FK], id_kurir [FK])`
* `DETAIL_PESANAN (id_pesanan [PK, FK], id_produk [PK, FK], qty_detail_pesanan, harga_satuan_detail_pesanan)`
* `PEMBAYARAN (id_pembayaran [PK], id_pesanan [FK], metode_pembayaran, tgl_pembayaran, status_pembayaran)`

---

## 5. Pemeriksaan BCNF (Boyce-Codd Normal Form)
Setiap penentu (*determinant*) pada skema 3NF di atas (`id_pelanggan`, `id_produk`, `id_kurir`, `id_pesanan`, `id_pembayaran`) seluruhnya merupakan kunci kandidat (*super key*). Oleh karena itu, skema ini sudah memenuhi standar BCNF.

---

## 6. Keputusan Penyimpanan Nilai Turunan
Nilai `subtotal_detail_pesanan` dan `total_bayar` diputuskan **tidak disimpan** pada tabel operasional transaksi. Nilai tersebut akan dihitung secara dinamis menggunakan kueri SQL agregasi (`SUM(qty * harga_satuan)`) untuk mencegah anomali inkonsistensi data jika terjadi perubahan rincian item.

---

## 7. Catatan Pembaruan ERD Proyek
Hasil normalisasi 3NF ini konsisten dengan struktur 6 entitas pada ERD Modul 3 (`Pelanggan`, `Produk`, `Kurir`, `Pesanan`, `Detail_Pesanan`, `Pembayaran`), sehingga tidak diperlukan perubahan entitas pada ERD konseptual.