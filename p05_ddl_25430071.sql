-- Skrip DDL Proyek Mandiri - Toko Daring
-- NPM: 25430071 | Nama: Arman Ardinansyah
-- Parameter P = 9 | Batas Max Qty Item per Baris = 11

CREATE DATABASE IF NOT EXISTS toko_071
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE toko_071;

-- Drop tabel terbalik dari anak ke induk
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS kurir;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS pelanggan;

-- 1. Tabel Pelanggan
CREATE TABLE pelanggan (
    id_pelanggan INT NOT NULL AUTO_INCREMENT,
    email_pelanggan VARCHAR(100) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    no_hp_pelanggan VARCHAR(15) NOT NULL,
    alamat_pelanggan VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_pelanggan),
    CONSTRAINT uq_pelanggan_email UNIQUE (email_pelanggan) -- AB-02
) ENGINE=InnoDB;

-- 2. Tabel Produk
CREATE TABLE produk (
    id_produk INT NOT NULL AUTO_INCREMENT,
    kode_produk VARCHAR(10) NOT NULL,
    nama_produk VARCHAR(100) NOT NULL,
    kategori_produk ENUM('Elektronik', 'Pakaian', 'Aksesoris', 'Buku') NOT NULL,
    harga_produk DECIMAL(12,2) NOT NULL,
    stok_produk INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produk),
    CONSTRAINT uq_produk_kode UNIQUE (kode_produk), -- AB-03
    CONSTRAINT ck_produk_harga CHECK (harga_produk >= 0),
    CONSTRAINT ck_produk_stok CHECK (stok_produk >= 0) -- AB-03 (stok tidak boleh negatif)
) ENGINE=InnoDB;

-- 3. Tabel Kurir
CREATE TABLE kurir (
    id_kurir INT NOT NULL AUTO_INCREMENT,
    nama_kurir VARCHAR(50) NOT NULL,
    layanan_kurir VARCHAR(50) NOT NULL,
    tarif_per_kg DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_kurir),
    CONSTRAINT ck_kurir_tarif CHECK (tarif_per_kg >= 0) -- AB-04
) ENGINE=InnoDB;

-- 4. Tabel Pesanan (Kepala Transaksi)
CREATE TABLE pesanan (
    id_pesanan INT NOT NULL AUTO_INCREMENT,
    no_invoice VARCHAR(20) NOT NULL,
    tgl_pesanan DATETIME NOT NULL,
    id_pelanggan INT NOT NULL,
    id_kurir INT NOT NULL,
    PRIMARY KEY (id_pesanan),
    CONSTRAINT uq_pesanan_invoice UNIQUE (no_invoice), -- AB-01
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id_pelanggan),
    CONSTRAINT fk_pesanan_kurir FOREIGN KEY (id_kurir) REFERENCES kurir (id_kurir)
) ENGINE=InnoDB;

-- 5. Tabel Detail Pesanan (Rincian Item Invoice)
CREATE TABLE detail_pesanan (
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    qty_detail_pesanan SMALLINT NOT NULL,
    harga_satuan_detail_pesanan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pesanan, id_produk),
    CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk),
    CONSTRAINT ck_detail_qty_min CHECK (qty_detail_pesanan > 0),
    CONSTRAINT ck_detail_qty_max CHECK (qty_detail_pesanan <= 11) -- Constraint berbasis P (P+2 = 11)
) ENGINE=InnoDB;

-- 6. Tabel Pembayaran
CREATE TABLE pembayaran (
    id_pembayaran INT NOT NULL AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    metode_pembayaran ENUM('Transfer Bank', 'E-Wallet', 'Kartu Kredit') NOT NULL,
    tgl_pembayaran DATETIME NOT NULL,
    status_pembayaran ENUM('pending', 'lunas', 'gagal') NOT NULL DEFAULT 'pending',
    PRIMARY KEY (id_pembayaran),
    CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan) ON DELETE CASCADE -- AB-06
) ENGINE=InnoDB;