from flask import Flask

app = Flask(__name__)
app.config['SECRET_KEY'] = 'very hard to guess string'
app.config['TEMPLATES_AUTO_RELOAD'] = True

from app import routes

