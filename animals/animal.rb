class Animal
    attr_accessor :name, :colors, :num_legs, :misc 

    def initialize(args) 
        @name = args.fetch(:name, "")
        @colors = args.fetch(:colors, [])
        @num_legs = args.fetch(:num_legs, 4)
        @misc = args.fetch(:misc, {})
    end

    def greet
        "Hi my name is #{name}"
    end

end