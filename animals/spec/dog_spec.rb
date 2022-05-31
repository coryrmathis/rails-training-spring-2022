require 'rspec'
require_relative '../dog.rb'

RSpec.describe Dog do

    describe "#greet" do 
        it "to contain the value of #name" do 
            name = "Hazel"
            dog = Dog.new({name: name})
            expect(dog.greet).to include(name)
        end
    end

    describe "#bark" do 
        it "returns the output of #greet with 'Bark Bark' prepended and appended" do 
            dog = Dog.new({name: "Hazel"})

            expect(dog.bark).to eq("Bark Bark #{dog.greet} Bark Bark")
        end
    end

    describe "#sit" do 
        it "returns the string 'sitting' if the dog has been told to sit" do 
            dog = Dog.new({name: "Hazel"})
            sitting = dog.sit
            expect(sitting).to eq("sitting")
            expect(dog.state).to eq("sitting")
        end
    end

    describe "#eat" do
        it "sets the dogs hungry state to false" do 
            dog = Dog.new({name: "Hazel"})
            dog.eat

            expect(dog.state[:hungry]).to eq(false)
        end
    end
end 