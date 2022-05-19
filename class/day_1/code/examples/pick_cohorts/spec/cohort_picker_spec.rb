require 'rspec'
require_relative '../cohort_picker'

RSpec.describe CohortPicker do 
  it "divides into two cohorts by default" do 
    picker = CohortPicker.new(students: "Cory, Michelle, Sammy, Walt, Hazel, Charlotte")
    cohorts = picker.run

    expect(cohorts.count).to eq(2)
  end
end