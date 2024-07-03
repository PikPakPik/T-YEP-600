import os
from app import app

if __name__ == '__main__':
    if os.environ.get('FLASK_ENV') == 'development':
        app.run(debug=True, use_reloader=True, use_debugger=True, host='0.0.0.0', port=5000)
    else:
        app.run(host='0.0.0.0', port=5000)