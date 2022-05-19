## Ruby Refresher

- [Ruby Refresher](#ruby-refresher)
  - [Inheritance](#inheritance)
  - [Idiomatic Ruby](#idiomatic-ruby)
  - [Hashes](#hashes)
  - [Keyword vs. Positional Arguments](#keyword-vs-positional-arguments)
  - [Modules](#modules)

We'll use the [Ruby docs](https://ruby-doc.org/core-2.7.2/) so keep them handy.

Ruby is an object oriented programming language. Every object is an instance of
a class and classes are defined by state (data) and
behavior (methods/functions).

There is a `./code` directory in each day folder for you to keep the code we write together.  This will be useful for you to commit and push up the code to share with your pairing partner as well as if you'd like some feedback from me.  Feel free to make a pull request against the `main` branch and tag me!

```ruby
class Dog

end

Dog.new
```

Instance with default state

```ruby
class Dog
 def initialize(name)
   @name = name
 end
end

Dog.new("Pearl")
```

Ruby comes with a repl - irb, or Interactive Ruby. You can type `irb` into your shell to fire this up. Let's type something in here.

Let's look at this instance of dog when we run our program. We will add a `puts` which is a method for printing out a value to the console. This is similar to a `console.log` in JS or `print()` in other languages.

```ruby
class Dog
 def initialize(name)
   @name = name
 end
end

puts Dog.new("Pearl")
```

We can run our program using `ruby example.rb` and see the output. It has an object id. And run it again. They have different object ids meaning that each time this program is run, a new instance of dog is created. Ruby does not remember state across instances.

In the initialize method, we are creating an instance variable. An instance variable can be distinguished from a regular variable by the `@` sign. In Ruby, each method holds its own local scope and does not know about local variables from other methods. An instance variable holds state across an instance of a class, meaning that all methods know about that instance variable and what information it is holding.

If we create a method, we can access our instance variable and use it within a method.

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def speak
    "Woof! My name is #{@name}"
  end
end

dog = Dog.new("Pearl")
puts dog.speak
```

We're also using _string interpolation_ in this example. We can embed Ruby directly into strings using `#{}`. Be aware that this only works with double-quoted strings, so `'My name is #{@name}'` would print exactly as written, without replacing `@name`.

Right now, our dog knows its name within the scope of the class, but what about calling a method that returns the dog's name? We cannot do that with our instance variable as is. We know that our instance of `Dog` knows about the instance variable `@name` so we can expose this by creating a method that returns the name of our dog. We'll also use the method `name` instead of the instance variable iternally. This makes our code more maintainable, in case we ever need to modify `name`:

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def speak
    "Woof! My name is #{name}"
  end

  def name
    @name
  end
end
```

Ruby has created a shortcut way to read our instance variable through an `attr_reader` which provides us this exact method under the hood. It is called a `getter` method in other languages.

```ruby
class Dog
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    "Woof! My name is #{name}"
  end
end
```

If we want to change the value of our instance method as well as read it, we need to use `attr_accessor`, which allows us to redefine our method. `attr_accesesor` combines `attr_reader`, our getter method, and `attr_writer`, a setter method, into one.

Here is what `attr_reader` and `attr_writer` are doing behind the scenes:

```ruby
def name
  @name
end

def name=(new_name)
  @name = new_name
end
```

These methods also prevent bugs: misspelling one of them will produce a `NoMethodError`, while misspelling an instance variable silently gives `nil` (or stashes data into the wrong place).

Writer methods (with `=`) are the only kind that need `self.` when called inside of an object, because an assignment with a bare word on the left-hand side is always considered a local variable:

```
# inside a method on Dog

name # => calls the name method
name = "something else" # => sets a local variable called name
self.name = "something else # => calls the name= method
```

### Inheritance

All dogs are animals and (in my head) all animals can introduce themselves by name. Let's create a super class or parent class of `Animal` that our `Dog` class will inherit from and a method of `speak` on that. Inheritance is denoted with the `<` in Ruby. This is a common pattern you will see across Rails as well.

```ruby
class Animal
  def speak(name)
   "My name is #{name}"
  end
end

class Dog < Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "Woof! #{super(name)}"
  end
end

dog = Dog.new("Pearl")
puts dog.speak
```

`super` allows us to access the method of the same name within the parent class. When we see `super` in code, that should signal to us to look in the parent class at a method named the same. If we change the method name, our program will be confused.

### Idiomatic Ruby

Ruby is said to be idiomatic because it reads similar to English. Methods that you would imagine wanting to call often exist: think `last`, `first`, `size`, etc. For example, you could create a dog house:

`dog_house = [Dog.new('Pearl'), Dog.new('Boggy'), Dog.new('Archie')]`

and find the first dog:
`puts dog_house.first`

also the size of the `dog_house`:
`puts dog_house.size`

**Solo Activity**

We want to create a method on `Dog` that returns all dog names in an array. A class method is denoted with `self`.
Using your Ruby docs, find a method that will take our array of dog objects and return only their names in a new array.

__BONUS__: What method goes through all our dog objects and returns the dog with the name of Riley?

```ruby
dog_house = [Dog.new('Pearl'), Dog.new('Boggy'), Dog.new('Archie')]

names = []

# using `each` which will iterate
dog_house.each do |dog|
  names << dog.name
end

# or (shorthand)
dog_house.each { |dog| names << dog.name }

puts names

# using `map` which will transform the data
names = dog_house.map do |dog|
  dog.name
end

# or (shorthand)
names = dog_house.map { |dog| dog.name }

# or (using to_proc, for advanced groups)
names = dog_house.map(&:name)

puts names

# When applied to a class method:
class Dog
  def self.names(dog_house)
    dog_house.map { |dog| dog.name }
  end
end

puts Dog.names(dog_house)

# BONUS
class Dog
  def self.find_by_name(name, dog_house)
    dog_house.find { |dog| dog.name == name }
  end
end
```

### Hashes
A hash is a data structure with key value pairs (a "map" or "dict" in other languages) and this structure is used a lot within the Rails ecosystem.
A hash also allows us to pass multiple pieces of data to a method without multiple arguments.

We denote a hash with `{}`. These are not always required; Ruby allows a final hash argument to a method to omit them:

```
def foo(x, y, opts)
  puts opts.inspect
end

foo(1, 2, this_is: "a hash", with_many: "values")
```

Let's update our `Dog` class to accept a hash with name, breed and birthday.

```ruby
class Dog < Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "Woof! #{super(name)}"
  end
end

dog = Dog.new(name: "Mia", breed: "border collie", birthday: "04/06/2006")
puts dog.speak
```

If we let our `dog` speak, what is being returned? And why?

```terminal
Woof! My name is {:name=>"Pearl", :breed=>"border collie", :birthday=>"04/06/2006"}
```

Let's drop into irb and use it as a playground. Each named key is a symbol you can access in hash:

```ruby
data = {name: "Mia"}

data[:name] # vs. data["name"]

# Alternatives
data.dig(:name) # For nested hashes
data.fetch(:name) # When a key is required
```

We need to update our initialize method to parse our hash into name, breed, and birthday and update our `attr_reader` to include breed and birthday.

```ruby
class Dog < Animal
  attr_accessor :name, :breed, :birthday

  def initialize(data)
    @name = data[:name]
    @breed = data[:breed]
    @birthday = data[:birthday]
  end

  def speak
    "Woof! #{super(name)}"
  end
end

dog = Dog.new(name: "Mia", breed: "border collie", birthday: "04/06/2006")
puts dog.speak
```

If we want to use our class method again, how can we return an array of just dog names?

```ruby
dog_house = [Dog.new(name: "Mia", breed: "border collie", birthday: "04/06/2006"), Dog.new(name: 'Pearl', breed: "mutt", birthday: "11/11/2011" ), Dog.new(name: 'Boggy', breed: "bulldog", birthday: "06/06/2016")]

names = dog_house.map do |dog|
  dog.name
end

puts names

Dog.names(dog_house)
```

### Keyword vs. Positional Arguments

In Ruby, we can pass as many arguments as we want into a method/function but prior to Ruby 2.0, the position of those arguments mattered. For example, we can pass name, breed and birthday without explicitly setting a key to the arguments:

```ruby
class Dog < Animal
  attr_accessor :name, :breed, :birthday

  def initialize(name, breed, birthday)
    @name = name
    @breed = breed
    @birthday = birthday
  end

  def speak
    "Woof! #{super(name)}"
  end
end

dog = Dog.new("Mia", "border collie", "04/06/2006")
```

This makes the assumption that we will always pass our `name`, `breed` and `birthday` in the same order.

Keyword arguments are a feature in Ruby 2.0 and higher. They're an alternative to positional arguments, and are similar (conceptually) to passing a hash to a function, but with better and more explicit errors.

With keyword arguments, it does not matter the order that we are passing the arguments in:

```ruby
class Dog < Animal
  attr_accessor :name, :breed, :birthday

  def initialize(name:, breed:, birthday:)
    @name = name
    @breed = breed
    @birthday = birthday
  end

  def speak
    "Woof! #{super(name)}"
  end
end

dog = Dog.new(breed: "border collie", name: "Mia", birthday: "04/06/2006")
```

This style is particularly useful when a method takes many arguments, most or all of which are optional.

### Modules
A module is a set of methods that can be included and utilized in a class. Sometimes you'll hear these referred to as "mixins" which is a helpful way to remember what modules do - they allow you to "mix in" additional behavior. We can only inherit from one class but we can include as many modules as we want.

Let's say we want to find out the age of our dog by their birthday. This might not be a method that needs to live on `Dog`, as we might want to use it in other classes like `Person` or `Cat` to find out the age of that object
Our module can take in the date and find the year, then compare it to the current year.

```ruby
require 'date'

module Age
  def age(birthdate)
    current_year = Date.today.year
    current_year - Date.parse(birthdate).year
  end
end

class Dog < Animal
  include Age

  attr_accessor :name, :breed, :birthday

  def initialize(name:, breed:, birthday:)
    @name = name
    @breed = breed
    @birthday = birthday
  end

  def speak
    "Woof! #{super(name)}"
  end

  def how_old
    "I am #{age(birthday)}!"
  end
end

dog = Dog.new(name: "Mia", breed: "border collie", birthday: "04/06/2006")
puts dog.how_old
```
