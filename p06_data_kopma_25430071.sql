-- =================================================================
-- Berkas: p06_data_kopma_25430071.sql
-- Deskripsi: Skrip pengisian data sampel dan pengujian DML Kopma
-- =================================================================

USE kopma_071;

-- -----------------------------------------------------------------
-- D.1 Mengisi Data Induk
-- -----------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
('K01', 'Dimas', 'kasir'),
('K02', 'Sari', 'kasir'),
('K03', 'Rina', 'kasir'),
('G01', 'Joko', 'gudang'),
('P01', 'Ketua Kopma', 'ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000.00, 120, 20),
('ATK-002', 'Buku Tulis 58', 'ATK', 6500.00, 80, 20),
('MNM-001', 'Air Mineral 600', 'minuman', 4000.00, 48, 24),
('MKN-001', 'Roti Cokelat', 'makanan', 5000.00, 6, 10);

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
('A-0457', '2301010001', 'Budi Santoso', 'Ilmu Komputer', '081234567890', 'aktif', '2026-01-15'),
('A-0458', '2301010002', 'Siti Rahma', 'Sistem Informasi', '082345678901', 'aktif', '2026-02-10'),
('A-0459', '2301010003', 'Andi Wijaya', 'Teknik Informatika', NULL, 'nonaktif', '2024-11-20');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
('CV Sumber ATK', '081198765432', 'Jl. Merdeka No. 12, Metro'),
('UD Segar Pangan', '082287654321', 'Jl. Ahmad Yani No. 45, Metro');

-- -----------------------------------------------------------------
-- D.2 Mencatat Nota Penjualan (PJ-2609-0142)
-- -----------------------------------------------------------------
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000.00);

-- Mengisi detail penjualan menggunakan INSERT INTO ... SELECT
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-002';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 1, harga_jual_barang FROM barang WHERE kode_barang = 'MNM-001';

-- Update stok barang setelah transaksi
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';

-- -----------------------------------------------------------------
-- D.3 Pengujian UPDATE dan DELETE dengan Mode Aman
-- -----------------------------------------------------------------
SET SESSION sql_safe_updates = 1;

-- Pengujian UPDATE aman (memakai syarat kolom kunci pada WHERE)
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;