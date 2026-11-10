-- =================================================================
-- Berkas: p07_kueri_kopma_25430071.sql
-- Penyusun: Arman Ardinansyah (NPM: 25430071)
-- =================================================================

USE kopma_071;

-- D.1 Proyeksi dan Penyaringan

-- 1. [KI-03] Barang di bawah stok minimum (perlu dipesan ulang)
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang, 
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- 2a. Barang kategori ATK atau Minuman (IN)
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'Minuman');

-- 2b. Nota transaksi pada rentang tanggal tertentu (BETWEEN)
SELECT no_penjualan, tgl_penjualan, total_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59';

-- 2c. Anggota tanpa nomor HP (IS NULL)
SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- D.2 Pola Teks dan Nilai Kosong

-- 3. Cari anggota yang namanya mengandung huruf 'a' & format label
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')       AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')          AS tgl_daftar_anggota,
       IFNULL(no_hp_anggota, '-')                           AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                   ELSE 'Tanpa diskon' END                  AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- D.3 Tanggal dan Perhitungan per Baris

-- 4. Lama keanggotaan dalam hari dan kategori (Baru < 180 hari / Lama)
SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF(CURRENT_DATE, tgl_daftar_anggota) AS lama_anggota_hari,
       CASE 
           WHEN DATEDIFF(CURRENT_DATE, tgl_daftar_anggota) < 180 THEN 'baru'
           ELSE 'lama'
       END AS kategori_keanggotaan
FROM anggota;

-- 5. Detail nota PJ-2609-0142 beserta subtotal
SELECT no_penjualan, kode_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal
FROM detail_penjualan
WHERE no_penjualan = 'PJ-2609-0142';