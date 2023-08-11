require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/statements", type: :request do
  
  # Statement. As you add validations to Statement, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Statement.create! valid_attributes
      get statements_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      statement = Statement.create! valid_attributes
      get statement_url(statement)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_statement_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      statement = Statement.create! valid_attributes
      get edit_statement_url(statement)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Statement" do
        expect {
          post statements_url, params: { statement: valid_attributes }
        }.to change(Statement, :count).by(1)
      end

      it "redirects to the created statement" do
        post statements_url, params: { statement: valid_attributes }
        expect(response).to redirect_to(statement_url(Statement.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Statement" do
        expect {
          post statements_url, params: { statement: invalid_attributes }
        }.to change(Statement, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post statements_url, params: { statement: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested statement" do
        statement = Statement.create! valid_attributes
        patch statement_url(statement), params: { statement: new_attributes }
        statement.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the statement" do
        statement = Statement.create! valid_attributes
        patch statement_url(statement), params: { statement: new_attributes }
        statement.reload
        expect(response).to redirect_to(statement_url(statement))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        statement = Statement.create! valid_attributes
        patch statement_url(statement), params: { statement: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested statement" do
      statement = Statement.create! valid_attributes
      expect {
        delete statement_url(statement)
      }.to change(Statement, :count).by(-1)
    end

    it "redirects to the statements list" do
      statement = Statement.create! valid_attributes
      delete statement_url(statement)
      expect(response).to redirect_to(statements_url)
    end
  end
end
