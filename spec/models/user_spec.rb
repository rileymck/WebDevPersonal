require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end


RSpec.describe "Students", type: :request do
  describe "GET /students" do
    it "returns a successful response" do
      get students_path
      expect(response).to have_http_status(:ok)
    end
  end
end
