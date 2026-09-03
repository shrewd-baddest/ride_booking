--
-- Database ownership:
--   PostgreSQL: source of truth for all sensitive and relational data.
--   Sqflite: non-sensitive driver and ride cache data for fast app access.
--
-- The Sqflite cache tables are defined in lib/Databases/database.dart and should
-- not be treated as authoritative. PostgreSQL table names use snake_case.
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS drivers (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL UNIQUE,
    email TEXT,
    license_number TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS rides (
    id BIGSERIAL PRIMARY KEY,
    driver_id BIGINT NOT NULL REFERENCES drivers(id),
    user_id BIGINT NOT NULL REFERENCES users(id),
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
    id BIGSERIAL PRIMARY KEY,
    ride_id BIGINT NOT NULL UNIQUE REFERENCES rides(id),
    base_fare NUMERIC(12, 2) NOT NULL CHECK (base_fare >= 0),
    distance_fare NUMERIC(12, 2) NOT NULL CHECK (distance_fare >= 0),
    time_fare NUMERIC(12, 2) NOT NULL CHECK (time_fare >= 0),
    total_fare NUMERIC(12, 2) NOT NULL CHECK (total_fare >= 0),
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (
        payment_status IN ('pending', 'completed', 'failed', 'refunded')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS rides_user_id_created_at_idx ON rides (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS rides_driver_id_created_at_idx ON rides (driver_id, created_at DESC);
CREATE INDEX IF NOT EXISTS payments_status_idx ON payments (payment_status);
CREATE INDEX IF NOT EXISTS rides_user_id_created_at_idx ON rides (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS rides_driver_id_created_at_idx ON rides (driver_id, created_at DESC);
CREATE INDEX IF NOT EXISTS payments_status_idx ON payments (payment_status);
-- Sqflite cache definitions are intentionally separate from these PostgreSQL
-- source-of-truth tables. They contain reduced, non-sensitive fields only.
-- CREATE TABLE IF NOT EXISTS drivers (
--     id BIGSERIAL PRIMARY KEY,
--     name TEXT NOT NULL,
--     phone_number TEXT NOT NULL UNIQUE,
--     email TEXT,
--     license_number TEXT NOT NULL UNIQUE,
--     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );
-- CREATE TABLE IF NOT EXISTS rides (
--     id BIGSERIAL PRIMARY KEY,
--     driver_id BIGINT NOT NULL REFERENCES drivers(id),
--     user_id BIGINT NOT NULL REFERENCES users(id),
--     from_location TEXT NOT NULL,
--     to_location TEXT NOT NULL,
--     distance NUMERIC(10, 2) NOT NULL CHECK (distance >= 0),
--     duration INTEGER NOT NULL CHECK (duration >= 0),
--     status TEXT NOT NULL DEFAULT 'requested' CHECK (
--         status IN (
--             'requested',
--             'accepted',
--             'in_progress',
--             'completed',
--             'cancelled'
--         )
--     ),
--     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );
