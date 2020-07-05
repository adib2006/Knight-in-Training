# Lists into
numbers = [2, 3, 4]
print(numbers[0], numbers[1], numbers[2])

# A list can also be empty
empty = []

mixed = [3, "Hi", [0, 1, 2]]# Mixed data

# Can be used to store sequence under one variable name
# A sequence of data

# Strings function similarly to lists
# Lists are similar to strings, but have a few key differences
message = "Hello World"
print(message[0])

# The main difference between lists and strings is that lists can contain all sorts of data types, not just one


aquarium = ["seal", "killer whale", "turtle", "whale shark"]

# List method (function)
# .pop(): returns the last element of the list. Updates list directly
whale_shark = aquarium.pop()
print(whale_shark)
print(aquarium)

# .remove(): Given an element, removes a specific from the list, does not return. Updates list directly
test = aquarium.remove("killer whale")
print(test) # Will be None because .remove() has no return value
print(aquarium)

# .append(): Given an element, it adds that element to the list
aquarium.append("seal")
print(aquarium)

aquarium.append("turtle")
print(aquarium)

aquarium.append("turtle animal")


# .insert(): Two parameters: index - position for the element to be inserted, element
# It adds it to the specific index (not before or after), and pushes the other elements back
aquarium.insert(1, "penguin")
print(aquarium)

aquarium.insert(3, "orangutan")
print(aquarium)

# len(): Gets length of list (this function can be called on other objects too, not just lists)
print(len(aquarium))
# aquarium.len() # This is incorrect

# .max(), .min(): returns the maximum and minimum value in a list
print(max(numbers), min(numbers)) # For numbers

print(max(aquarium), min(aquarium)) # Returns alphabetical order

# .count(): Given an element, returns how many times that element is in the list
aquarium.count("turtle")
print(aquarium.count("turtle"))

# list(): converts any data type to a list
# The following data types are all sequenced, but not lists
vowel_string = 'aeiou' # string
print(list(vowel_string))

vowel_tuple = ('a', 'e', 'i', 'o', 'u') # tuple
print(list(vowel_tuple))

vowel_list = ['a', 'e', 'i', 'o', 'u'] # list
print(list(vowel_list))

# 5/24/20
message = "hello" # string
print(list(message)) #['h', 'e', 'l', 'l', 'o']

dict_message = {"a": 1, "b": 2} # dictionary
print(list(dict_message)) # ['a', 'b']


numbers = [0, 1, 2, 3, 4] # range(5)
print(3 in numbers) # True
print(7 in numbers) # False

# Tuples
# "Read-only", values can't be changed after they are created
# Tuples are good for securing your data
# Examples: Birthday

# Creating Tuples
tuple_a = (0, 1, 2)
print(type(tuple_a), tuple_a)

empty_tuple = ()

actually_an_int = (1) # tuple with one element
print(type(actually_an_int), actually_an_int)

one_element_tuple = (1,)
print(one_element_tuple)
# Just like lists, tuples can be accessed by index
print(tuple_a[0], tuple_a[1], tuple_a[2]) # tuple_a[3] IndexError for accessing an index that does not exist, just like with lists
#tuple_a[1] = 100
print(tuple_a[1] + 100) # This is fine, we are simply using the value inside tuple_a[1], not reassi
# tuple_a[1] = tuple_a[1] + 100 # crashes

# We can't add elements to a tuple
# my_list.append() # no equivalent in tuples


# However, entire variable is reassignable.
my_tuple = 3
print(type(my_tuple), my_tuple)
# Reassigning a normal variable
a = 5
a = "hello"
print(a)

# Tuple usage vs List usage
grocery_list = ["eggs", "broccoli", "apples"] # sequential data that is usually of the same type
grocery_tuple = ("eggs", 3, "Safeway") # Package of data. Tuples are often used in functions to return a data "package", of non-sequential data, but data that is relevant to each other in some way

def return_banking_info():
  return ("Chase", 54167892, 37264849823.00) # Package of data with Bank name, account_id, amount

a = (1,2,3,4,5,5)
print(a.count(5))

print(len(a))

my_list = ['a', 'b', 'c']
print(tuple(my_list))