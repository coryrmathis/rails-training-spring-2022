require_relative "./dog.rb"

options = {
    name: "Hazel", 
    species: "dog", 
    colors: ["brown", "white"], 
    num_legs: 4, 
    misc: { location: "St. Louis, MO", age: 10 }
}

animal = Animal.new(options)

# puts animal.greet

dog = Dog.new(options)

p dog.class.superclass