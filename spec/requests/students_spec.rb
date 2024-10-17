require 'rails_helper'

# Request specs for the Students resource focusing on HTTP requests
RSpec.describe "Students", type: :request do
  # GET /students (index)
  describe "GET /students" do
    context "when students exist" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15") }
      let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", minor: "Statistics", graduation_date: "2026-05-15") }

      # Test 1: Returns a successful response and displays the search form
      it "returns a successful response and displays the search form" do
        get students_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Search') # Ensure search form is rendered
      end

      # Test 2: Ensure it does NOT display students without a search
      it "does not display students until a search is performed" do
        get students_path
        expect(response.body).to_not include("Aaron")
      end
    end

    # Test 3: Handle missing records or no search criteria provided
    context "when no students exist or no search is performed" do
      it "displays a message prompting to search" do
        get students_path
        expect(response.body).to include("Please provide at least one search criteria")
      end
    end
  end

  # Search functionality
  describe "GET /students (search functionality)" do
    let!(:student1) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15") }
    let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", minor: "Statistics", graduation_date: "2026-05-15") }

    # Test 4: Search by major
    it "returns students matching the major" do
      get students_path, params: { search: { major: "Computer Science BS" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 5: Search by graduation date (before)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { graduation_date: "2026-01-01", grad_date_filter: "before" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 6: Search by graduation date (after)
    it "returns students graduating after the given date" do
      get students_path, params: { search: { graduation_date: "2025-12-01", grad_date_filter: "after" } }
      expect(response.body).to include("Jackie")
      expect(response.body).to_not include("Aaron")
    end
  end

  # POST /students (create)
  describe "POST /students" do
    context "with valid parameters" do
      # Test 7: Create a new student and ensure it redirects
      it "creates a new student and redirects" do
        expect {
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)  # Expect redirect after creation
        follow_redirect!
        expect(response.body).to include("Aaron")  # Student's details in the response
      end

      # Test 8: Create new student and ensure it returns 201 Created status
      it "creates a new student and returns 201 Created status" do
        expect{
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Aaron")
      end

      # Test #9: Ensure student is not created and returns 422 status
      it "does not create a new student and returns 422 Unprocessable Entity status" do
        expect{
          post students_path, params: { student: { first_name: "", last_name: "", school_email: "invalidemail", major: "", minor: "", graduation_date: "" } }
        }.to_not change(Student, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("errors")
      end
    end
  end

  # GET /students/:id (show)
  describe "GET /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15") }

    # Test 10: Fetch students details and ensure it returns 200 OK status
    it "returns the student's details and ensure it returns 200 OK status" do
      get student_path(student)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Aaron")
    end

    # Test 11: Fetch students details and ensure the correct details are included in the responce body
    it "returns the correct student details in the response body" do
      get student_path(student)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Aaron")
      expect(response.body).to include("Gordon")
      expect(response.body).to include("gordon@msudenver.edu")
      expect(response.body).to include("Computer Science BS")
      expect(response.body).to include("Mathematics")
      expect(response.body).to include("2025-05-15")
    end

    # Test 12: Fetchs a non-existent student's details and ensure it returns 404 Not Found status
    it "returns a 404 Not Found status when the student does not exist" do
      get student_path(id: 9999)
      expect(response).to have_http_status(:not_found)
    end
  end


  # DELETE /students/:id (destroy)
  describe "DELETE /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", minor: "Mathematics", graduation_date: "2025-05-15") }

    # Test 13: Attempts to delete a non-existent student and ensure it returns 404 Not Found status
    it "returns a 404 Not Found status when the student does not exist" do
      delete student_path(id: 9999)
      expect(response).to have_http_status(:not_found)
    end

    # Test 14: Returns a 404 when trying to delete a non-existent student
    it "returns a 404 status when trying to delete a non-existent student" do
      delete "/students/9999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
