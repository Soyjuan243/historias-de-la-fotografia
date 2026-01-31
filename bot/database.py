import sqlite3
import os

DB_PATH = "bot_database.db"

def get_connection():
    return sqlite3.connect(DB_PATH)

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    # Developers table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS developers (
        discord_id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        status TEXT DEFAULT 'disponible',
        active BOOLEAN DEFAULT 1,
        strikes INTEGER DEFAULT 0,
        specialty TEXT,
        work_count INTEGER DEFAULT 0
    )
    ''')

    # Migration for existing tables
    try:
        cursor.execute("ALTER TABLE developers ADD COLUMN specialty TEXT")
        cursor.execute("ALTER TABLE developers ADD COLUMN work_count INTEGER DEFAULT 0")
    except sqlite3.OperationalError:
        # Columns already exist
        pass

    # Projects table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        client TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT DEFAULT 'pendiente',
        ticket_id TEXT,
        assigned_dev TEXT
    )
    ''')

    # Tickets table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS tickets (
        channel_id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        creator_id TEXT NOT NULL,
        name TEXT NOT NULL,
        status TEXT DEFAULT 'abierto',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    ''')

    # Logs table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    ''')

    conn.commit()
    conn.close()

# Developer CRUD
def register_dev(discord_id, username, specialty=None):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO developers (discord_id, username, specialty)
    VALUES (?, ?, ?)
    ON CONFLICT(discord_id) DO UPDATE SET
        username=excluded.username,
        active=1,
        specialty=COALESCE(excluded.specialty, developers.specialty)
    ''', (discord_id, username, specialty))
    conn.commit()
    conn.close()

def update_work_count(discord_id, amount, absolute=False):
    conn = get_connection()
    cursor = conn.cursor()
    if absolute:
        cursor.execute('UPDATE developers SET work_count = ? WHERE discord_id = ?', (amount, discord_id))
    else:
        cursor.execute('UPDATE developers SET work_count = work_count + ? WHERE discord_id = ?', (amount, discord_id))
    conn.commit()
    conn.close()

def get_dev(discord_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM developers WHERE discord_id = ?', (discord_id,))
    dev = cursor.fetchone()
    conn.close()
    return dev

def update_dev_status(discord_id, status):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE developers SET status = ? WHERE discord_id = ?', (status, discord_id))
    conn.commit()
    conn.close()

def add_strike(discord_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE developers SET strikes = strikes + 1 WHERE discord_id = ?', (discord_id,))
    conn.commit()
    conn.close()

def get_available_devs():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM developers WHERE status = 'disponible' AND active = 1")
    devs = cursor.fetchall()
    conn.close()
    return devs

def delete_dev(discord_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM developers WHERE discord_id = ?', (discord_id,))
    conn.commit()
    conn.close()

# Project CRUD
def create_project(name, type, client, priority, ticket_id=None):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO projects (name, type, client, priority, ticket_id)
    VALUES (?, ?, ?, ?, ?)
    ''', (name, type, client, priority, ticket_id))
    project_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return project_id

def get_projects():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM projects')
    projects = cursor.fetchall()
    conn.close()
    return projects

def update_project_status(project_id, status):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE projects SET status = ? WHERE id = ?', (status, project_id))
    conn.commit()
    conn.close()

def assign_dev_to_project(project_id, dev_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE projects SET assigned_dev = ? WHERE id = ?', (dev_id, project_id))
    conn.commit()
    conn.close()

def get_project_by_ticket(ticket_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM projects WHERE ticket_id = ?', (ticket_id,))
    project = cursor.fetchone()
    conn.close()
    return project

# Ticket CRUD
def create_ticket(channel_id, type, creator_id, name):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
    INSERT INTO tickets (channel_id, type, creator_id, name)
    VALUES (?, ?, ?, ?)
    ''', (channel_id, type, creator_id, name))
    conn.commit()
    conn.close()

def close_ticket(channel_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE tickets SET status = 'cerrado' WHERE channel_id = ?", (channel_id,))
    conn.commit()
    conn.close()

def get_ticket(channel_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM tickets WHERE channel_id = ?', (channel_id,))
    ticket = cursor.fetchone()
    conn.close()
    return ticket

def add_log(action):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO logs (action) VALUES (?)', (action,))
    conn.commit()
    conn.close()
