
from flask import render_template, url_for, redirect, session, flash
from app import app
from flask_wtf import FlaskForm
from wtforms import SubmitField, StringField
from wtforms.validators import DataRequired, NumberRange
import random

def clear_session():
  for key in session.keys():
    session.pop(key)

class ChoicesForm(FlaskForm):
  text = StringField(u'Type your choice', validators=[
    DataRequired(u'You must submit a value.')
  ])
  submit = SubmitField(u'Submit')

class Player:
  def __init__(self, name):
    self.level = 1
    self.name = name
    self.health = 110
    self.title = "Rookie "

  def __str__(self):
    return "Level: " + str(self.level) + " Name: " + self.name + " Health: " + str(self.health) + " Title: " + self.title

  def toJSON(self):
    return self.__dict__


@app.route('/')
@app.route('/index')
def index():
  return render_template('index.html')

@app.route('/game', methods = ["GET","POST"])
def game():
  form = ChoicesForm()
  if form.validate_on_submit():
    submitted_text = form.text.data
    # session is a dictionary
    if 'player' not in session:
      session['player'] = Player(submitted_text).toJSON()
    redirect(url_for('play'))
  return render_template('game.html', form=form)


@app.route('/play', methods = ["GET","POST"])
def play():
  player = session['player']
  print(player)
  choices = ["sleeping", "training", "eating breakfast", "eating lunch", "eating dinner", "in trouble", "under attack"]
  print(choices)
  alive = True
  form = ChoicesForm() # This is a setup code
  print(player)
  # Functionality code
  if form.validate_on_submit():
    # Form submitted
    submitted_text = form.text.data
    if submitted_text == "eating lunch" or submitted_text == "eating dinner" or submitted_text == "eating breakfast":
      print("Eat healthy!")
      player['health'] = player['health'] + 25
    elif submitted_text == "sleeping":
      print("Good night!")
      player["level"] = player["level"] + 1
    elif submitted_text == "training":
        print("Good luck!")
        player["level"] = player["level"] + 1
    elif submitted_text == "in trouble" or submitted_text == "under attack":
      print("WATCH OUT!")
      under_attack = True
    else:
        print("You don't want to do that...")
    print(submitted_text)
    flash(u'Submitted successfully', 'success')
    return redirect(url_for('play'))  # reload game page if not done playing
  else:
    # Form submission failed
    flash(u'Submission failed', 'danger')
  return render_template('play.html', form=form) # Render the screen


@app.route('/about')
def about():
  return render_template('about.html')