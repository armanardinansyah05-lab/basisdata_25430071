### D. Langkah Percobaan: Normalisasi Kasus Kopma

#### D.1 Dari UNF ke 1NF
* **UNF (Unnormalized Form)**:
  `NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan }, jumlah_penjualan, diskon_penjualan, total_penjualan)`

* **1NF (First Normal Form)**:
  Menghilangkan grup berulang dengan menetapkan kunci primer komposit `(no_nota_penjualan, kode_barang)`:
  `NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)`

---

#### D.2 Menuliskan Dependensi Fungsional
* **FD1**: `no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota` (Aturan Bisnis AB-01)
* **FD2**: `kode_petugas -> nama_petugas`
* **FD3**: `no_anggota -> nama_anggota` (Aturan Bisnis AB-05)
* **FD4**: `kode_barang -> nama_barang`
* **FD5**: `(no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan` (Aturan Bisnis AB-04)
* **FD6**: `qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan` (Nilai Turunan)

**Jawaban Titik Analisis 1:**
`harga_satuan_detail_penjualan` diletakkan pada kunci komposit `(no_nota_penjualan, kode_barang)` karena harga transaksi merupakan catat sejarah (*snapshot*) saat transaksi terjadi sesuai AB-04. Jika harga disimpan di tabel master `barang`, saat harga barang naik di kemudian hari, seluruh catatan transaksi lama akan ikut berubah secara otomatis dan merusak akurasi laporan omzet historis.

---

#### D.3 Menuju 2NF dan 3NF
* **2NF (Second Normal Form)**:
  Memisahkan ketergantungan parsial (FD1 dan FD4 dipisah dari kunci komposit):
  * `PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, no_anggota, bayar_penjualan)`
  * `DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)`
  * `BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`

* **3NF (Third Normal Form)**:
  Memisahkan ketergantungan transitif (FD2 dan FD3 dipisah dari entitas penjualan) serta menghapus nilai turunan (`subtotal`, `total`):
  * `PETUGAS (kode_petugas, nama_petugas, peran_petugas)`
  * `ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)`
  * `PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)`
  * `DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)`
  * `BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`

**Jawaban Titik Analisis 2:**
Nilai total tidak disimpan pada tabel operasional transaksi untuk menghindari anomali inkonsistensi data jika rincian item berubah. Namun pada tabel arsip/historis, data sudah bersifat permanen dan tidak akan diubah lagi, sehingga menyimpan total diperbolehkan demi mempercepat kinerja kueri pelaporan tanpa perlu menghitung ulang seluruh rincian transaksi.

---

#### D.4 Mencocokkan dengan Skema Kanonik & BCNF
* **Penerapan Kunci Pengganti (*Surrogate Key*)**:
  Seluruh tabel diubah menggunakan `id_*` (integer) sebagai kunci primer utama, sedangkan kode alami seperti `no_nota_penjualan` atau `nim_anggota` dijadikan kunci unik.
* **Pemeriksaan BCNF (Boyce-Codd Normal Form)**:
  Setiap penentu (*determinant*) dalam skema kanonik (seperti `id_petugas`, `id_anggota`, `id_barang`, `id_penjualan`) sudah merupakan kunci kandidat (*super key*), sehingga seluruh tabel sudah memenuhi BCNF.

**Jawaban Titik Analisis 3:**
Informasi pemasok kini disimpan pada relasi transaksi `pembelian` dan `detail_pembelian`. Keuntungannya adalah Kopma dapat membeli barang dari berbagai pemasok yang berbeda seiring waktu tanpa terikat kaku pada satu pemasok di tabel master barang.