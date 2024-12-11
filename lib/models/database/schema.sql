-- Users table
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    company_id TEXT,
    work_start_time TEXT,
    work_end_time TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    opt_out_ranking BOOLEAN DEFAULT FALSE,
    last_strength_test_date TIMESTAMP
);

-- User Settings
CREATE TABLE user_settings (
    user_id TEXT PRIMARY KEY,
    has_theraband BOOLEAN DEFAULT FALSE,
    allow_standing_exercises BOOLEAN DEFAULT TRUE,
    allow_sitting_exercises BOOLEAN DEFAULT TRUE,
    allow_strengthening BOOLEAN DEFAULT TRUE,
    allow_mobilisation BOOLEAN DEFAULT TRUE,
    notification_enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Exercises
CREATE TABLE exercises (
    id INTEGER PRIMARY KEY,
    video_id TEXT NOT NULL,
    name TEXT NOT NULL,
    preparation TEXT,
    execution TEXT,
    goal TEXT,
    tips TEXT,
    muscle_group TEXT NOT NULL,
    category TEXT NOT NULL,
    is_sitting BOOLEAN,
    is_theraband BOOLEAN,
    is_dynamic BOOLEAN,
    is_one_sided BOOLEAN
);

-- User Progress
CREATE TABLE user_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    exercise_id INTEGER,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed BOOLEAN,
    cancelled BOOLEAN,
    skipped BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(id)
);

-- Strength Tests
CREATE TABLE strength_tests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    muscle_group TEXT NOT NULL,
    repetitions INTEGER,
    test_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Companies
CREATE TABLE companies (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    domain TEXT
);

-- Daily Stats
CREATE TABLE daily_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    date DATE,
    exercises_completed INTEGER DEFAULT 0,
    unique_muscle_groups_trained INTEGER DEFAULT 0,
    streak_days INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
