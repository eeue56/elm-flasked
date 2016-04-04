from flask import Flask, current_app
from flask import jsonify, redirect, url_for, escape
from flask import request, session
from flask import g as Globals

from actions import update



app = Flask(__name__, static_url_path='')
app.model = 0

@app.route('/<path:path>')
def static_proxy(path):
    return app.send_static_file(path)

@app.route('/')
def index():
    return app.send_static_file('index.html')


@app.route('/api', methods=['POST'])
def api():
    blob = request.get_json()
    app.model = update(blob, app.model)

    return jsonify({
        'model': app.model
    })


app.secret_key = ''


if __name__ == "__main__":
    app.run(debug=True)
