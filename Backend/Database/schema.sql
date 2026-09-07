-- ============================================================
-- PostgreSQL SOURCE-OF-TRUTH SCHEMA
-- UUID-based primary and foreign keys
-- ============================================================
-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS drivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL UNIQUE,
    email TEXT,
    license_number TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS rides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL REFERENCES drivers(id),
    user_id UUID NOT NULL REFERENCES users(id),
    from_location TEXT NOT NULL,
    to_location TEXT NOT NULL,
    distance NUMERIC(10, 2) NOT NULL CHECK (distance >= 0),
    duration INTEGER NOT NULL CHECK (duration >= 0),
    status TEXT NOT NULL DEFAULT 'requested' CHECK (
        status IN (
            'requested',
            'accepted',
            'in_progress',
            'completed',
            'cancelled'
        )
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL UNIQUE REFERENCES rides(id),
    base_fare NUMERIC(12, 2) NOT NULL CHECK (base_fare >= 0),
    distance_fare NUMERIC(12, 2) NOT NULL CHECK (distance_fare >= 0),
    time_fare NUMERIC(12, 2) NOT NULL CHECK (time_fare >= 0),
    total_fare NUMERIC(12, 2) NOT NULL CHECK (total_fare >= 0),
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (
        payment_status IN (
            'pending',
            'completed',
            'failed',
            'refunded'
        )
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- INDEXES
CREATE INDEX IF NOT EXISTS rides_user_id_created_at_idx ON rides (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS rides_driver_id_created_at_idx ON rides (driver_id, created_at DESC);
CREATE INDEX IF NOT EXISTS payments_status_idx ON payments (payment_status);