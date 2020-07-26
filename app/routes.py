
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
    self.health = 105
    self.title = "Rookie "

  def __str__(self):
    return "Level: " + str(self.level) + " Name: " + self.name + " Health: " + str(self.health) + " Title: " + self.title

  def toJSON(self):
    return self.__dict__


@app.route('/')
@app.route('/index')
def index():
  session.clear()
  return render_template('index.html')

@app.route('/game', methods = ["GET","POST"])
def game():
  form = ChoicesForm()
  if form.validate_on_submit():
    submitted_text = form.text.data

    # DEBUGGING ONLY
    # print("Is form validating???")
    # print("Submitted:", submitted_text)

    # session is a dictionary
    if 'player' not in session:
      session['player'] = Player(submitted_text).toJSON()
      print(session['player'])
    if 'last_move' not in session:
        session['last_move'] = None
    if 'last_message' not in session:
        session['last_message'] = None
    # Only go to play page if the player has been created
    return redirect(url_for('play')) # MUST use `return` keyword for redirect
  return render_template('game.html', form=form)


@app.route('/play', methods = ["GET","POST"])
def play():
  # Deletes previous messages:
  session.pop('_flashes', None)
  player = session['player']
  if player['level'] >= 25:
      player['title'] = "General "
  elif player['level'] >= 10:
      player['title'] = "Master "
  player['health'] = player['health'] - 5
  if player['health'] <= 0:
      return redirect(url_for('game_over'))
  form = ChoicesForm() # This is a setup code
  flash("Name: " + player['title'] + " " + player['name'])
  flash("Health: " + str(player['health']))
  flash("Level: " + str(player['level']))
  if session['last_message'] is not None:
      flash(session['last_message'])
  # Functionality code
  random_float = random.random()
  if form.validate_on_submit():
    # Form submitted
    submitted_text = form.text.data
    # submitted_text is the user's current move that they typed in.
    if session['last_move'] == "under attack":
        session['last_message'] = "WATCH OUT! What is your plan? (Choices: fight back, defend, run away)"
        if submitted_text == 'fight back':
            if random_float <= 0.49:
                player['health'] = player['health'] - 35
                session['last_message'] = 'Ouch! You lost 35 health.'
            else:
                player["level"] = player["level"] + 10
        elif submitted_text == 'defend':
            if random_float <= 0.25:
                session['last_message'] = 'Ouch! You lost 25 health!'
                player['health'] = player['health'] - 25
            else:
                session['last_message'] = "Hooray! You succeeded!"
                player["level"] =  player["level"] + 2
        elif submitted_text == 'run away':
            session['last_message'] = "You ran away, lost 0 health."
    else:
        if submitted_text == "eating lunch" or submitted_text == "eating dinner" or submitted_text == "eating breakfast":
          session['last_message'] = "Eat healthy!"
          player['health'] = player['health'] + 25
        elif submitted_text == "sleeping":
          session['last_message'] = "Good night!"
          player["level"] = player["level"] + 1
          player['health'] = player['health'] + 10
        elif submitted_text == "training":
            session['last_message'] = "Good luck!"
            player["level"] = player["level"] + 2.5
        elif submitted_text == "in trouble" or submitted_text == "under attack":
          session['last_message'] = "WATCH OUT! What's your plan? (Choices: fight back, defend, run away.)"
          under_attack = True
        else:
            flash("You don't want to do that...")

    # These actions should happen after every turn.
    print("Successful")
    session['last_move'] = submitted_text
    return redirect(url_for('play'))  # reload game page if not done playing


  else:
    # Form submission failed
    print("Failed")
  return render_template('play.html', form=form) # Render the screen

@app.route('/game_over')
def game_over():
  session.clear()
  return render_template('game_over.html')

@app.route('/about')
def about():
  return render_template('about.html')
