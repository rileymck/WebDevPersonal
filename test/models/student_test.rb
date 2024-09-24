require "test_helper"

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #This test makes sure no one can make a student without a first name
  test "should not be valid when first_name is missing" do
    student = Student.new(
      first_name: nil,
      last_name: "Smith",
      school_email: "jane.smith@msudenver.edu",
      major: "Mathematics",
      minor: "Physics",
      graduation_date: "2025-06-15"
    )
  
    assert_not student.valid?, "Student should not be valid when the first_name is missing"
    
    # Log the errors for missing first_name
    puts student.errors.full_messages
    
    assert student.errors[:first_name].any?, "There should be an error on the missing first_name"
  end

  #This test makes sure no one can make a student without a last name
  test "should not be valid when last_name is missing" do
    student = Student.new(
      first_name: "Jane",
      last_name: nil,
      school_email: "jane.smith@msudenver.edu",
      major: "Mathematics",
      minor: "Physics",
      graduation_date: "2025-06-15"
    )
  
    assert_not student.valid?, "Student should not be valid when the last_name is missing"
    
    # Log the errors for missing last_name
    puts student.errors.full_messages
    
    assert student.errors[:last_name].any?, "There should be an error on the missing last_name"
  end

  #This test makes sure no one can make a student without a major
  test "should not be valid when major is missing" do
    student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      school_email: "jane.smith@msudenver.edu",
      major: nil,
      minor: "Physics",
      graduation_date: "2025-06-15"
    )
  
    assert_not student.valid?, "Student should not be valid when the major is missing"
    
    # Log the errors for missing last_name
    puts student.errors.full_messages
    
    assert student.errors[:major].any?, "There should be an error on the missing major"
  end

  #This test makes sure no one can make a student without a minor
  test "should not be valid when minor is missing" do
    student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      school_email: "jane.smith@msudenver.edu",
      major: "Physics",
      minor: nil,
      graduation_date: "2025-06-15"
    )
  
    assert_not student.valid?, "Student should not be valid when the minor is missing"
    
    # Log the errors for missing last_name
    puts student.errors.full_messages
    
    assert student.errors[:minor].any?, "There should be an error on the missing minor"
  end

  #This test makes sure no one can make a student without a graduation_date
  test "should not be valid when graduation_date is missing" do
    student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      school_email: "jane.smith@msudenver.edu",
      major: "Physics",
      minor: "Physics",
      graduation_date: nil
    )
  
    assert_not student.valid?, "Student should not be valid when the graduation_date is missing"
    
    # Log the errors for missing last_name
    puts student.errors.full_messages
    
    assert student.errors[:graduation_date].any?, "There should be an error on the missing graduation_date"
  end


  #This test makes sure that no two people can have the same email
  test 'validates uniqueness of school_email' do
    one = Student.create!(
      first_name: 'John',
      last_name: 'Doe',
      school_email: 'test@msu.edu',
      major: 'Computer Science',
      minor: 'Mathematics',
      graduation_date: '2024-05-15'
    )
    
    two = Student.new(
      first_name: 'Jane',
      last_name: 'Doe',
      school_email: 'test@msu.edu',
      major: 'Physics',
      minor: 'Chemistry',
      graduation_date: '2025-06-15'
    )
    
    assert_not two.valid?, 'Student should be invalid if the email is not unique'
  end

  #This test ensures that a student can be saved with valid attributes
  test "should save student with valid attributes" do
    student = Student.create!(
      first_name: "John",
      last_name: "Doe",
      school_email: "john.unique.email@msudenver.edu", # Ensure a unique email
      major: "Computer Science",
      minor: "Mathematics",
      graduation_date: "2024-09-16"
    )
    assert student.persisted?, "Student was not persisted"
  end


  #This test makes sure that a student can be created without a picture
  #test "should be valid without a profile picture" do
    #student = Student.new(
      #first_name: "Jane",
      #last_name: "Smith",
      #school_email: "jane.smith@msudenver.edu",
      #major: "Mathematics",
      #minor: "Physics",
      #graduation_date: "2025-06-15",
      #profile_picture: nil # No profile picture provided
    #)
    
    #assert student.valid?, "Student should be valid without a profile picture"
    #assert_empty student.errors[:profile_picture], "There should be no error on profile_picture"
  #end
  


  teardown do
    Student.destroy_all
  end
  


  test "should be valid without a profile picture" do
    student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      school_email: "unique.jane.smith@msudenver.edu", # Ensure a unique email for this test
      major: "Mathematics",
      minor: "Physics",
      graduation_date: "2025-06-15",
      profile_picture: nil
    )
    
    assert student.valid?, "Student should be valid without a profile picture"
    assert_empty student.errors[:profile_picture], "There should be no error on profile_picture"
  end
  
  
end
