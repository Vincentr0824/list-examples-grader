CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

#if [[ -f student-submission/ListExamples.java ]]
#then 
#    echo "test"
#fi

#!/bin/bash

# Define paths and filenames
submission_dir="student-submission"
grading_dir="grading-area"
test_file="TestListExamples.java"
student_file="ListExamples.java"

# Clone the repository
git clone "$submission_dir" "$grading_dir"

# Move student submission and test file into grading-area
cp -r *.java grading-area
cp -r student-submission/ListExamples.java grading-area
cp -r lib grading-area


# Compile tests and student's code
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java

javac -cp .:junit.jar "$test_file" "$student_file" 2> compile_errors.txt

# Check for compilation errors
if [ -s "compile_errors.txt" ]; then
    echo "Error: Compilation failed. Please check your code."
    cat "compile_errors.txt"
    exit 1
fi

# Run the tests and capture the output
java -cp .:junit.jar:hamcrest.jar org.junit.runner.JUnitCore $(basename "$test_file" .java) | tee test_results.txt

# Extract the grade from the test results (you may need to customize this based on your test output)
grade=$(grep -oP "(?<=Tests run: )[0-9]+" test_results.txt)

# Define the pass/fail threshold (customize as per your requirements)
pass_threshold=80

# Check if the grade is above the pass threshold
if [ "$grade" -ge "$pass_threshold" ]; then
    echo "Congratulations! You passed with a grade of $grade."
else
    echo "Sorry, you did not pass. Your grade: $grade."
fi

