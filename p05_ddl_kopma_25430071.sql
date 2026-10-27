-- Berkas DDL Praktikum Kopma Modul 5
-- NPM: 25430071 | Nama: Arman Ardinansyah

USE kopma_071;

-- Penghapusan tabel dimulai dari anak ke induk (urutan terbalik)
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- 1. Tabel Master Petugas
CREATE TABLE petugas (
    id_petugas SMALLINT NOT NULL AUTO_INCREMENT,
    kode_petugas CHAR(3) NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran_petugas ENUM('kasir', 'gudang', 'ketua') NOT NULL,
    PRIMARY KEY (id_petugas),
    CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

-- 2. Tabel Master Anggota
CREATE TABLE anggota (
    id_anggota INT NOT NULL AUTO_INCREMENT,
    no_anggota CHAR(5) NOT NULL,
    nim_anggota CHAR(10) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    prodi_anggota VARCHAR(60) NOT NULL,
    no_hp_anggota VARCHAR(15) NULL,
    status_anggota ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
    tgl_daftar_anggota DATE NOT NULL,
    PRIMARY KEY (id_anggota),
    CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
    CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota)
) ENGINE=InnoDB;

-- 3. Tabel Master Barang
CREATE TABLE barang (
    id_barang INT NOT NULL AUTO_INCREMENT,
    kode_barang VARCHAR(10) NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang ENUM('ATK', 'makanan', 'minuman') NOT NULL,
    harga_jual_barang DECIMAL(12,2) NOT NULL,
    stok_barang INT NOT NULL DEFAULT 0,
    stok_min_barang INT NOT NULL DEFAULT 5,
    PRIMARY KEY (id_barang),
    CONSTRAINT uq_barang_kode UNIQUE (kode_barang),
    CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
    CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
    CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

-- 4. Tabel Master Pemasok
CREATE TABLE pemasok (
    id_pemasok INT NOT NULL AUTO_INCREMENT,
    nama_pemasok VARCHAR(100) NOT NULL,
    telepon_pemasok VARCHAR(15) NULL,
    alamat_pemasok VARCHAR(200) NULL,
    PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- 5. Tabel Transaksi Penjualan (Kepala Nota)
CREATE TABLE penjualan (
    id_penjualan INT NOT NULL AUTO_INCREMENT,
    no_nota_penjualan CHAR(12) NOT NULL,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas SMALLINT NOT NULL,
    id_anggota INT NULL,
    bayar_penjualan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan),
    CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan),
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. Tabel Detail Penjualan (Rincian Item Nota)
CREATE TABLE detail_penjualan (
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_penjualan SMALLINT NOT NULL,
    harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
    CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
    CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

-- 7. Tabel Transaksi Pembelian (Kepala Faktur)
CREATE TABLE pembelian (
    id_pembelian INT NOT NULL AUTO_INCREMENT,
    no_faktur_pembelian VARCHAR(20) NOT NULL,
    tgl_pembelian DATE NOT NULL,
    id_pemasok INT NOT NULL,
    status_pembelian ENUM('dipesan', 'diterima') NOT NULL DEFAULT 'dipesan',
    PRIMARY KEY (id_pembelian),
    CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

-- 8. Tabel Detail Pembelian (Rincian Faktur)
CREATE TABLE detail_pembelian (
    id_pembelian INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_pembelian INT NOT NULL,
    harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pembelian, id_barang),
    CONSTRAINT fk_dbeli_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
    CONSTRAINT fk_dbeli_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
    CONSTRAINT ck_dbeli_qty CHECK (qty_detail_pembelian > 0)
) ENGINE=InnoDB;