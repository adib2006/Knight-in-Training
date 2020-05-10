import random


class Player:
    def __init__(self, name):
        self.level = 1
        self.name = name
        self.health = 110
        self.title = "Rookie "

    def __str__(self):
        return "Level: " + str(self.level) + " Name: " + self.name + " Health: " + str(self.health) + " Title: " + self.title
name = input("What is your name, traveler?: ")
second_player = Player(name)
print(second_player)

choices = ["sleeping","training","eating breakfast","eating lunch","eating dinner","in trouble","under attack"]
print(choices)
alive = True
while alive:
    if second_player.level >= 25:
        second_player.title = "General "
    elif second_player.level >= 10:
        second_player.title = "Master "

    second_player.health = second_player.health - 10        # Because of daily hunger, you lose 10 health every round.

    print("Player level is:", second_player.level)
    print("Player name is:", second_player.title + second_player.name)
    print("Player's health: ", second_player.health)



    if second_player.health <= 0:
        print("GAME OVER! Better luck next time!")
        alive = False
        break

    command = input("What are you doing, traveler?: ")
    if command == "sleeping":
        print("Good night!")
        second_player.level = second_player.level + 1
    elif command == "training":
        print("Good luck!")
        second_player.level = second_player.level + 1
    elif command == "eating breakfast" or command == "eating lunch" or command == "eating dinner":
        print("Eat healthy!")
        second_player.health = second_player.health + 25
    elif command == "in trouble" or command == "under attack":
        print("WATCH OUT!")
        under_attack = True
        while under_attack:
            choice = input("What's your plan?: ")
            random_float = random.random()  # returns a float/decimal between 0.0 and 1.0
            # Under attack: What's your plan?
            # Choices: Fight back, defend, run away
            # Run away: Always successful, you don't lose any health
            # Fight back: 49% chance of winning, 51% chance of losing. If you win, gain 7 levels. If you lose, lose 35 health points.
            # Defend: 75% chance of winning, 25% chance of failing. If you win, gain 2 levels. If you lose, lose 25 health points.
            print('run away', 'fight back', 'defend')
            if choice == "run away":
                print("You ran away, lost 0 health.")
                under_attack = False
            elif choice == "fight back":
                if random_float <= 0.49:
                    second_player.health = second_player.health - 35
                    print('Ouch! You lost 35 health.')
                else:
                    second_player.level = second_player.level + 10
                under_attack = False
            elif choice == "defend":
                if random_float <= 0.25:
                    print('Ouch! You lost 25 health!')
                    second_player.health = second_player.health - 25
                else:
                    print("Hooray! You succeeded!")
                    second_player.level = second_player.level + 2
                under_attack = False
            else:
                print("You can't do that...")

    else:
        print("You don't want to do that...")





# Python Loops
# choices = ["walking", "running"]
#for choice in choices:
 # print(choice)
# walking
# running

# for character in "word":
#   print(character)
# w
# o
# r
# d

# i = 0
# while i < 10:
#   print(i)
#   i = i + 1
#
#
# class Point:
#     def __init__(self,x,y):
#      def move(self):
#         print("move")
#     def draw(self):
        # print("draw")