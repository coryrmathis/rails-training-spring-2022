class Animal
    attr_accessor :name, :legs

    def initialize(name: "", legs: 4)
        @name = name
        @legs = legs
    end

    def speak
        "Hi my name is #{name}"
    end

end
