import sqlite3
import os
from datetime import datetime

DATABASE_NAME = "bot_database.db"

def get_connection():
    return sqlite3.connect(DATABASE_NAME)

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    # Developers table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS developers (
            discord_id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            status TEXT DEFAULT 'disponible',
            is_active INTEGER DEFAULT 1,
            strikes INTEGER DEFAULT 0
        )
    ''')

    # Projects table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS projects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            client TEXT,
            priority TEXT,
            status TEXT DEFAULT 'pendiente',
            ticket_id INTEGER,
            FOREIGN KEY (ticket_id) REFERENCES tickets (id)
        )
    ''')

    # Tickets table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tickets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            channel_id INTEGER UNIQUE,
            type TEXT NOT NULL,
            creator_id INTEGER NOT NULL,
            status TEXT DEFAULT 'abierto',
            fecha TEXT DEFAULT CURRENT_TIMESTAMP,
            project_id INTEGER,
            FOREIGN KEY (project_id) REFERENCES projects (id)
        )
    ''')

    # Assignments table (to track current and past assignments)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS assignments (
            dev_id INTEGER,
            project_id INTEGER,
            assigned_at TEXT DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (dev_id, project_id),
            FOREIGN KEY (dev_id) REFERENCES developers (discord_id),
            FOREIGN KEY (project_id) REFERENCES projects (id)
        )
    ''')

    conn.commit()
    conn.close()

# Developer functions
def register_developer(discord_id, username):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT OR REPLACE INTO developers (discord_id, username, status, is_active, strikes)
        VALUES (?, ?, 'disponible', 1, 0)
    ''', (discord_id, username))
    conn.commit()
    conn.close()

def get_developer(discord_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM developers WHERE discord_id = ?', (discord_id,))
    dev = cursor.fetchone()
    conn.close()
    return dev

def get_available_developers():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM developers WHERE status = 'disponible' AND is_active = 1")
    devs = cursor.fetchall()
    conn.close()
    return devs

def update_developer_status(discord_id, status):
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

# Project functions
def create_project(name, p_type, client, priority):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO projects (name, type, client, priority, status)
        VALUES (?, ?, ?, ?, 'pendiente')
    ''', (name, p_type, client, priority))
    project_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return project_id

def get_projects(status=None):
    conn = get_connection()
    cursor = conn.cursor()
    if status:
        cursor.execute('SELECT * FROM projects WHERE status = ?', (status,))
    else:
        cursor.execute('SELECT * FROM projects')
    projects = cursor.fetchall()
    conn.close()
    return projects

def get_project(project_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM projects WHERE id = ?', (project_id,))
    project = cursor.fetchone()
    conn.close()
    return project

def get_project_by_name(name):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM projects WHERE name = ?', (name,))
    project = cursor.fetchone()
    conn.close()
    return project

def update_project_status(project_id, status):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE projects SET status = ? WHERE id = ?', (status, project_id))
    conn.commit()
    conn.close()

# Ticket functions
def create_ticket(channel_id, t_type, creator_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO tickets (channel_id, type, creator_id, status)
        VALUES (?, ?, ?, 'abierto')
    ''', (channel_id, t_type, creator_id))
    ticket_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return ticket_id

def close_ticket(channel_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE tickets SET status = 'cerrado' WHERE channel_id = ?", (channel_id,))
    conn.commit()
    conn.close()

def link_ticket_project(ticket_id, project_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE tickets SET project_id = ? WHERE id = ?', (project_id, ticket_id))
    cursor.execute('UPDATE projects SET ticket_id = ? WHERE id = ?', (ticket_id, project_id))
    conn.commit()
    conn.close()

def get_ticket_by_channel(channel_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM tickets WHERE channel_id = ?', (channel_id,))
    ticket = cursor.fetchone()
    conn.close()
    return ticket

# Assignment functions
def assign_developer(dev_id, project_id):
    conn = get_connection()
    cursor = conn.cursor()
    # Check if dev is already assigned to an active project (simplified check)
    cursor.execute("SELECT status FROM developers WHERE discord_id = ?", (dev_id,))
    dev_status = cursor.fetchone()
    if dev_status and dev_status[0] == 'ocupado':
        conn.close()
        return False, "Developer ya está ocupado."

    cursor.execute('''
        INSERT INTO assignments (dev_id, project_id)
        VALUES (?, ?)
    ''', (dev_id, project_id))

    cursor.execute("UPDATE developers SET status = 'ocupado' WHERE discord_id = ?", (dev_id,))
    cursor.execute("UPDATE projects SET status = 'en curso' WHERE id = ?", (project_id,))

    conn.commit()
    conn.close()
    return True, "Asignado con éxito."

def unassign_developer(dev_id, project_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM assignments WHERE dev_id = ? AND project_id = ?', (dev_id, project_id))
    cursor.execute("UPDATE developers SET status = 'disponible' WHERE discord_id = ?", (dev_id,))
    conn.commit()
    conn.close()

def get_project_assignment(project_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT dev_id FROM assignments WHERE project_id = ?', (project_id,))
    assignment = cursor.fetchone()
    conn.close()
    return assignment
