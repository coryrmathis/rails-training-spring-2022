
students_string = "Adrian Ledesma, Astrid Moore, Brandon Moore, Daniel Olivarez, Evan Liddell, Hasan Beytas, Ivy Beatty, Nick Murphy, Nick Shew, Roman Romaniuk, Samantha Wade, Steph Hasz, Steven Cherry, Thomas McKibben, Will Parsons"

students = students_string.split(", ")

random_students = students.shuffle

halfway = random_students.count/2
cohort_1 = random_students[0..halfway]
cohort_2 = random_students[halfway+1..-1]
puts "-----COHORT 1-----"
puts cohort_1
puts
puts "-----COHORT 2-----"
puts cohort_2