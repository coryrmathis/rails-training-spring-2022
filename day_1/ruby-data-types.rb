# strings
# puts "HELLO"
# puts 'Single quotes'.class
# puts String.new("asdfasdf")
# puts <<HELLO 
# asdfasdfa
# asdfasdf
# asdfasdf
# HELLO

# Numbers
one = 1
two = 2
three = 3.4

# Arrays

numbers = [one, two, three]
numbers = Array.new(1,2)
numbers = Array.new(3,2..4)
numbers = %w[michelle sammy walt]
# pp numbers

# Hash

family = {"dad" => "Cory", "mom" => "Michelle", "sons" => %w[Sammy Walt]}
family = {
    dad: "Cory", 
    mom: "Michelle", 
    sons: ["Sammy", "Walt"]
}
# puts family

# Symbols

dad = :dad
# p dad
# p dad.class

# Doesn't work!

# dad = dad:
# p dad 
# p dad.class

# Objects
# p Class
# p Object

# p Class.class
# p Object.class

# class

class Animal
end

animal = Animal.new

p animal
