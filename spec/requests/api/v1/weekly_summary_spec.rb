require 'rails_helper'

RSpec.describe "Api::V1::WeeklySummary", type: :request do
  describe "GET /api/v1/weekly_summary" do
    it "returns a successful response" do
      get "/api/v1/weekly_summary"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include("message")
    end
  end
end
