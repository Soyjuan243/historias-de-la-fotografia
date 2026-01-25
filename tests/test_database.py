import os
import sqlite3
import pytest
import sys

# Add bot directory to path so we can import database
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../bot')))

import database

@pytest.fixture(autouse=True)
def setup_database():
    # Use a test database
    database.DATABASE_NAME = "test_bot_database.db"
    database.init_db()
    yield
    # Clean up
    if os.path.exists(database.DATABASE_NAME):
        os.remove(database.DATABASE_NAME)

def test_register_and_get_developer():
    database.register_developer(12345, "TestDev")
    dev = database.get_developer(12345)
    assert dev is not None
    assert dev[1] == "TestDev"
    assert dev[2] == "disponible"

def test_create_and_get_project():
    p_id = database.create_project("Test Project", "Script", "Client A", "media")
    project = database.get_project(p_id)
    assert project is not None
    assert project[1] == "Test Project"
    assert project[5] == "pendiente"

def test_assign_developer():
    database.register_developer(12345, "TestDev")
    p_id = database.create_project("Test Project", "Script", "Client A", "media")

    success, msg = database.assign_developer(12345, p_id)
    assert success is True

    dev = database.get_developer(12345)
    assert dev[2] == "ocupado"

    project = database.get_project(p_id)
    assert project[5] == "en curso"

    assignment = database.get_project_assignment(p_id)
    assert assignment[0] == 12345

def test_unassign_developer():
    database.register_developer(12345, "TestDev")
    p_id = database.create_project("Test Project", "Script", "Client A", "media")
    database.assign_developer(12345, p_id)

    database.unassign_developer(12345, p_id)
    dev = database.get_developer(12345)
    assert dev[2] == "disponible"

def test_strikes():
    database.register_developer(12345, "TestDev")
    database.add_strike(12345)
    dev = database.get_developer(12345)
    assert dev[4] == 1

def test_get_project_by_name():
    database.create_project("Named Project", "Mapa", "Client B", "alta")
    project = database.get_project_by_name("Named Project")
    assert project is not None
    assert project[1] == "Named Project"
