class CohortPicker
  attr_accessor :students, :num_cohorts

  def initialize(students: "", num_cohorts: 2)
    @students = students
    @num_cohorts = num_cohorts
  end

  def run
    students_list = students.split(",")

    random_students = students_list.shuffle

    halfway = random_students.count/2

    return [
      random_students[0..halfway], 
      random_students[halfway+1..-1]
    ]
  end
end