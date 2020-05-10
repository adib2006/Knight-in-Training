#PRACTICE BROWSER FOR PYTHON: https://www.w3schools.com/python/python_exercises.asp




# x = 10
# x = x + 10
# print(x)
#
# name = "Johnny Boy"
# if len(name) < 3:
#     print('More letters, please!')
# elif len(name) > 50:
#     print('Too many letters!')
# else:
#     print('Great choice!')
#
# weight = int(input('weight:'))
# unit  = input('(K)g or (L)bs: ')
# if unit.upper() == "L":
#     converted = weight * 0.45
#     print(f"You are {converted} kilograms.")
# else:
#     converted = weight / 0.45
#     print(f"You are {converted} pounds.")
#
# i = 1
# while i <= 5:
#     print(i)
#     i = i + 1
# print('Done')
#
# a = 1
# while a <= 4:
#     print('*' * a)
#     a = a + 1
# print('Done')
#
# secret = 9
# tries = 0
# limit = 3
# while tries < limit:
#     guess = int(input('Guess: '))
#     tries += 1
#     if guess == secret:
#         print('You won!')
#         break
# else:
#     print('Sorry! You failed.')
#
# names = ['John', 'Bob', 'Sarah', 'Caroline']
# print(names[2:4])
#
# numbers = [3, 6, 2, 8, 4, 10]
# max = numbers[0]
# for number in numbers:
#     if number > max:
#         max = number
# print(max)
# print(numbers)
#
# matrix = [
#     [1,2,3],
#     [4,5,6],
#     [7,8,9]
# ]
#
# import random
# for i in range(3):
#     print(random.random())


# command = ""
# while command.lower() != "quit":
#     command = input("> ")
#     if command.lower() != "pause":
#         print("Jacky starts moving to the treasure.")
#     elif command.lower() != "begin":
#         print("Jacky stopped.")
#     else:
#         print("I'm sorry. I don't understand that.")

# This is our python demo
item1 = "banana"
item2 = "avocado"
item3 = "milk"
# This is our grocery list.
grocery_list = ["banana", "avocado", "milk"]
mystery_list = [item1, item2, item3]
print(grocery_list)
print(mystery_list)
guess = input("Guess what's inside the bag: ")
print("Your guess was: " + guess)
print("Your guess was: %s" % guess)
if guess == "milk":
  print("GOOD JOB!")
elif guess == "avocado":
  print("WAY TO GO!")
elif guess == "banana":
  print("AWESOME")
else:
  print("Sorry! That wasn't in the bag.")

# Tuples: similar to list, but uses () instead of []
# Tuples are immutable, lists are mutable
my_tuple = (3, 4, 5, 7)
list_version = list(my_tuple)
# list_version: this is now mutable

# immutability (of data types)
# What does it mean if a data type is "mutable"
# mutagen = changable
print(my_tuple)
print(list_version)
print(list_version[3])
print(my_tuple[0])


items_dictionary = {
  "keyboard": 40,
  "headphones": 30,
  "laptop": 800
}
items_dictionary["headphones"]
print(items_dictionary["headphones"])

print(items_dictionary)
print(items_dictionary.keys())
print(items_dictionary.values())
del items_dictionary["headphones"]
print("microphone" in items_dictionary)
items_dictionary["microphone"] = 65


print("microphone" in items_dictionary)
print(items_dictionary)

tuple = (9,90,99)
list = [1,2,3]
print(tuple)
print(list)








