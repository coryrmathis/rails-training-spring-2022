require_relative "./animal.rb"

class Dog < Animal
    attr_accessor :state

    def initialize(args)
        super
        @state = args.fetch(:state, "standing")
    end

    def bark 
        "Bark Bark #{greet} Bark Bark"
    end

    def sit 
        self.state = "sitting"
    end
end