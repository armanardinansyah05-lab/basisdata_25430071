-- =================================================================
-- Berkas: p07_kueri_25430071.sql
-- Penyusun: Arman Ardinansyah (NPM: 25430071)
-- Deskripsi: Skrip Kueri SELECT & Fungsi Skalar Proyek Mandiri Toko Daring
-- =================================================================

USE toko_071;

-- [KI-01]
-- Pertanyaan: Tampilkan daftar produk kategori 'Elektronik' diurutkan dari harga termurah.
-- Hasil yang diharapkan: Menampilkan produk elektronik beserta harga dan stoknya.
SELECT id_produk, kode_produk, nama_produk, harga_produk, stok_produk
FROM produk
WHERE kategori_produk = 'Elektronik'
ORDER BY harga_produk ASC;

-- [KI-02]
-- Pertanyaan: Cari pelanggan yang beralamat di area 'Z.A. Pagar Alam' menggunakan operator LIKE.
-- Hasil yang diharapkan: Menampilkan data pelanggan yang alamatnya mengandung kata 'Z.A. Pagar Alam'.
SELECT id_pelanggan, nama_pelanggan, email_pelanggan, alamat_pelanggan
FROM pelanggan
WHERE alamat_pelanggan LIKE '%Z.A. Pagar Alam%';

-- [KI-03]
-- Pertanyaan: Tampilkan produk yang harganya berada di rentang Rp 40.000 hingga Rp 150.000 (BETWEEN).
-- Hasil yang diharapkan: Daftar produk dengan harga antara 40rb sampai 150rb.
SELECT kode_produk, nama_produk, kategori_produk, harga_produk
FROM produk
WHERE harga_produk BETWEEN 40000.00 AND 150000.00
ORDER BY harga_produk ASC;

-- [KI-04]
-- Pertanyaan: Tampilkan transaksi pembayaran yang menggunakan metode 'Transfer Bank' atau 'E-Wallet' (IN).
-- Hasil yang diharapkan: Baris data pembayaran khusus metode Transfer Bank dan E-Wallet.
SELECT id_pembayaran, id_pesanan, metode_pembayaran, status_pembayaran, tgl_pembayaran
FROM pembayaran
WHERE metode_pembayaran IN ('Transfer Bank', 'E-Wallet');

-- [KI-05]
-- Pertanyaan: Tampilkan pelanggan yang belum mencantumkan nomor HP atau datanya kosong (IS NULL).
-- Hasil yang diharapkan: Menampilkan baris pelanggan jika ada no_hp_pelanggan bernilai NULL.
SELECT id_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan
FROM pelanggan
WHERE no_hp_pelanggan IS NULL;

-- [KI-06]
-- Pertanyaan: Tampilkan nama pelanggan beserta format nomor WhatsApp (+62) menggunakan fungsi string CONCAT & SUBSTRING.
-- Hasil yang diharapkan: Kolom baru no_whatsapp dengan awalan '+62' menggantikan angka '0' di depan.
SELECT nama_pelanggan, 
       CONCAT('+62', SUBSTRING(no_hp_pelanggan, 2)) AS no_whatsapp, 
       email_pelanggan
FROM pelanggan;

-- [KI-07]
-- Pertanyaan: Tampilkan daftar pesanan bulan September 2026 dengan format tanggal Indonesia (DATE_FORMAT).
-- Hasil yang diharapkan: Kolom tgl_pesanan tampil rapi sesuai format standar Indonesia (DD-MM-YYYY HH:i).
SELECT id_pesanan, no_invoice, 
       DATE_FORMAT(tgl_pesanan, '%d-%m-%Y %H:%i') AS tgl_pesanan_formatted
FROM pesanan
WHERE tgl_pesanan BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59';

-- [KI-08]
-- Pertanyaan: Kategorikan produk berdasarkan status ketersediaan stoknya menggunakan ekspresi CASE.
-- Hasil yang diharapkan: Kolom baru status_stok berisi 'Stok Melimpah' (>=100), 'Stok Sedang' (50-99), atau 'Stok Menipis' (<50).
SELECT nama_produk, stok_produk,
       CASE 
           WHEN stok_produk >= 100 THEN 'Stok Melimpah'
           WHEN stok_produk BETWEEN 50 AND 99 THEN 'Stok Sedang'
           ELSE 'Stok Menipis'
       END AS status_stok
FROM produk;

-- [KI-09]
-- Pertanyaan: Tampilkan 3 produk termahal yang dijual di toko online menggunakan pembatasan LIMIT.
-- Hasil yang diharapkan: 3 baris produk dengan harga tertinggi.
SELECT kode_produk, nama_produk, kategori_produk, harga_produk
FROM produk
ORDER BY harga_produk DESC
LIMIT 3;

-- [KI-10]
-- Pertanyaan: Hitung perkalian aritmatika subtotal per barang (qty * harga satuan) pada tabel detail_pesanan.
-- Hasil yang diharapkan: Kolom kalkulasi subtotal per barang dalam rincian invoice.
SELECT id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan,
       (qty_detail_pesanan * harga_satuan_detail_pesanan) AS subtotal
FROM detail_pesanan;

-- [KI-11] (Membutuhkan JOIN)
-- Pertanyaan: Siapa nama pelanggan yang melakukan transaksi pesanan invoice 'INV-20260920-001'?
-- Alasan: Data 'nama_pelanggan' ada di tabel 'pelanggan', sedangkan data 'no_invoice' ada di tabel 'pesanan'. Kueri membutuhkan JOIN antara tabel pelanggan dan pesanan.

-- [KI-12] (Membutuhkan JOIN)
-- Pertanyaan: Apa nama produk yang dibeli pada pesanan ID 1 beserta nama kurir pengirimnya?
-- Alasan: Data 'nama_produk' ada di tabel 'produk', 'nama_kurir' ada di tabel 'kurir', dan relasi transaksi ada di tabel 'pesanan' & 'detail_pesanan'. Membutuhkan JOIN multi-tabel.