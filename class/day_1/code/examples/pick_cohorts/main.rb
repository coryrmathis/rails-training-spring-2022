require_relative './cohort_picker.rb'

students_string = File.read('./students.csv')

picker = CohortPicker.new(students: students_string)

cohorts = picker.run 

File.open('cohorts.txt', 'w+') do |f|
  cohorts.each_with_index do |cohort, index|
    f.write("-----COHORT #{index+1}-----\n")
    cohort.each{ |student| f.write(student + "\n") }
    f.write("\n")
  end
end


