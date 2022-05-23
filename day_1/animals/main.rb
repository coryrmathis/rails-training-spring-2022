require_relative "./animal.rb"
require_relative "./dog.rb"
require 'smarter_csv'

animal = Animal.new(name: "Spot", legs: 3)

# p animal.name
# p animal.legs

# p animal.speak
#####################

malcolm = Dog.new(name: "Malcolm")

p malcolm.speak

malcolm.name = "Jerry"

jerry = malcolm

p malcolm.speak

animals = SmarterCSV.process("./animals.csv")

p animals