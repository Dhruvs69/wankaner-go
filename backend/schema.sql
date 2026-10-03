CREATE DATABASE IF NOT EXISTS wankaner_go;
USE wankaner_go;

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'vendor', 'customer', 'delivery') DEFAULT 'customer',
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS addresses (
    id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    title VARCHAR(50),
    address TEXT NOT NULL,
    lat DOUBLE,
    lng DOUBLE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vendors (
    id VARCHAR(100) PRIMARY KEY,
    owner_id VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    rating DOUBLE DEFAULT 5.0,
    is_promoted BOOLEAN DEFAULT false,
    is_open BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    image_url TEXT,
    distance VARCHAR(50),
    lat DOUBLE DEFAULT 0.0,
    lng DOUBLE DEFAULT 0.0,
    review_count INT DEFAULT 0,
    total_rating_score DOUBLE DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS items (
    id VARCHAR(100) PRIMARY KEY,
    vendor_id VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category VARCHAR(100),
    image_url TEXT,
    is_vegetarian BOOLEAN DEFAULT true,
    is_available BOOLEAN DEFAULT true,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS item_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DOUBLE NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS item_addons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DOUBLE NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(100) PRIMARY KEY,
    customer_id VARCHAR(100) NOT NULL,
    vendor_id VARCHAR(100) NOT NULL,
    delivery_partner_id VARCHAR(100),
    total_amount DOUBLE NOT NULL,
    status ENUM('pending', 'processing', 'ready', 'out for delivery', 'delivered', 'cancelled') DEFAULT 'pending',
    delivery_address TEXT NOT NULL,
    delivery_lat DOUBLE,
    delivery_lng DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(100) NOT NULL,
    item_id VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    quantity INT NOT NULL,
    selected_variant_name VARCHAR(100),
    selected_variant_price DOUBLE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_item_addons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT NOT NULL,
    addon_name VARCHAR(100) NOT NULL,
    addon_price DOUBLE NOT NULL,
    FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    id VARCHAR(100) PRIMARY KEY,
    vendor_id VARCHAR(100) NOT NULL,
    customer_id VARCHAR(100) NOT NULL,
    order_id VARCHAR(100) NOT NULL,
    rating DOUBLE NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
