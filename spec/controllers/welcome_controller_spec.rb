require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

	describe "GET #index" do

		before do
			get :index
		end

		it "returns HTTP success" do
			expect(response).to have_http_status(:success)
		end

		it "renders the welcome page" do
			expect(response).to render_template("index")
		end

	end
end