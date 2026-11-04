-- =================================================================
-- Berkas: p06_data_25430071.sql
-- Penyusun: Arman Ardinansyah (NIM: 25430071)
-- Deskripsi: Skrip DML Tugas Mandiri Toko Daring (toko_071)
--            Parameter P = 9 (Qty Maks = 11, Minimal Transaksi = 90)
-- =================================================================

USE toko_071;

-- -----------------------------------------------------------------
-- 1. Pengisian Data Induk / Master
-- -----------------------------------------------------------------
INSERT INTO pelanggan (email_pelanggan, nama_pelanggan, no_hp_pelanggan, alamat_pelanggan) VALUES
('arman@example.com', 'Arman Ardinansyah', '081234567801', 'Jl. Z.A. Pagar Alam No. 10, Bandar Lampung'),
('budi@example.com', 'Budi Pratama', '081234567802', 'Jl. Raden Intan No. 45, Bandar Lampung'),
('cinta@example.com', 'Cinta Laura', '081234567803', 'Jl. Teuku Umar No. 88, Bandar Lampung'),
('dina@example.com', 'Dina Mariana', '081234567804', 'Jl. Sultan Agung No. 12, Bandar Lampung'),
('eko@example.com', 'Eko Prasetyo', '081234567805', 'Jl. Gajah Mada No. 99, Bandar Lampung');

INSERT INTO produk (kode_produk, nama_produk, kategori_produk, harga_produk, stok_produk) VALUES
('ELEK-001', 'Mouse Wireless Silent', 'Elektronik', 75000.00, 150),
('ELEK-002', 'Keyboard Mechanical RGB', 'Elektronik', 350000.00, 80),
('PAK-001', 'Kaos Polos Cotton 30s', 'Pakaian', 45000.00, 200),
('PAK-002', 'Jaket Hoodie Unisex', 'Pakaian', 125000.00, 60),
('AKS-001', 'Gantungan Kunci Kustom', 'Aksesoris', 15000.00, 300),
('BUK-001', 'Buku Pemrograman SQL', 'Buku', 85000.00, 50);

INSERT INTO kurir (nama_kurir, layanan_kurir, tarif_per_kg) VALUES
('JNE Express', 'Reguler', 10000.00),
('J&T Express', 'NEXT DAY', 18000.00),
('Pos Indonesia', 'Kilat Khusus', 12000.00);

-- -----------------------------------------------------------------
-- 2. Pengisian Transaksi Utama (Pesanan, Detail, Pembayaran)
-- -----------------------------------------------------------------
-- Transaksi 1 (2026-09-20)
INSERT INTO pesanan (no_invoice, tgl_pesanan, id_pelanggan, id_kurir) VALUES
('INV-20260920-001', '2026-09-20 09:30:00', 1, 1);

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 1, id_produk, 2, harga_produk FROM produk WHERE kode_produk = 'ELEK-001';

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 1, id_produk, 1, harga_produk FROM produk WHERE kode_produk = 'PAK-002';

INSERT INTO pembayaran (id_pesanan, metode_pembayaran, tgl_pembayaran, status_pembayaran) VALUES
(1, 'Transfer Bank', '2026-09-20 09:35:00', 'lunas');

-- Transaksi 2 (2026-09-21)
INSERT INTO pesanan (no_invoice, tgl_pesanan, id_pelanggan, id_kurir) VALUES
('INV-20260921-001', '2026-09-21 14:15:00', 2, 2);

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 2, id_produk, 5, harga_produk FROM produk WHERE kode_produk = 'PAK-001';

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 2, id_produk, 2, harga_produk FROM produk WHERE kode_produk = 'AKS-001';

INSERT INTO pembayaran (id_pesanan, metode_pembayaran, tgl_pembayaran, status_pembayaran) VALUES
(2, 'E-Wallet', '2026-09-21 14:20:00', 'lunas');

-- Transaksi 3 (2026-09-22)
INSERT INTO pesanan (no_invoice, tgl_pesanan, id_pelanggan, id_kurir) VALUES
('INV-20260922-001', '2026-09-22 11:00:00', 3, 3);

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 3, id_produk, 1, harga_produk FROM produk WHERE kode_produk = 'ELEK-002';

INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT 3, id_produk, 3, harga_produk FROM produk WHERE kode_produk = 'BUK-001';

INSERT INTO pembayaran (id_pesanan, metode_pembayaran, tgl_pembayaran, status_pembayaran) VALUES
(3, 'Kartu Kredit', '2026-09-22 11:05:00', 'lunas');

-- Update Stok Produk Terjual
UPDATE produk SET stok_produk = stok_produk - 2 WHERE kode_produk = 'ELEK-001';
UPDATE produk SET stok_produk = stok_produk - 1 WHERE kode_produk = 'PAK-002';
UPDATE produk SET stok_produk = stok_produk - 5 WHERE kode_produk = 'PAK-001';
UPDATE produk SET stok_produk = stok_produk - 2 WHERE kode_produk = 'AKS-001';
UPDATE produk SET stok_produk = stok_produk - 1 WHERE kode_produk = 'ELEK-002';
UPDATE produk SET stok_produk = stok_produk - 3 WHERE kode_produk = 'BUK-001';

-- -----------------------------------------------------------------
-- 3. Pengujian UPDATE dengan Mode Aman
-- -----------------------------------------------------------------
SET SESSION sql_safe_updates = 1;

UPDATE produk
SET harga_produk = ROUND(harga_produk * 1.05, -2)
WHERE kategori_produk = 'Pakaian' AND id_produk > 0;