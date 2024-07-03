from app import app, db
from models.User import User
from flask_bcrypt import generate_password_hash

@app.cli.command('database:fixtures')
def fixtures():
    password = generate_password_hash('azertyuiop', 12).decode('utf-8')
    userAdmin = User(firstname="Admin", lastname="Admin", email="admin@tyep600.org", password=password)
    db.session.add(userAdmin)
    user = User(firstname="User", lastname="User", email="user@tyep600.org", password=password)
    db.session.add(user)
    
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(f"Error adding user")
        print(f"Exception: {e}")

    print('Fixtures loaded')

@app.cli.command('database:create')
def createDatabase():
    db.create_all()
    print('Database created')

@app.cli.command('database:delete')
def deleteDatabase():
    db.drop_all()
    print('Database deleted')