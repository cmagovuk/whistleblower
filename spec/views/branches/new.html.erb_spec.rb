require 'rails_helper'

RSpec.describe "branches/new", type: :view do
  before(:each) do
    assign(:branch, Branch.new())
  end

  it "renders new branch form" do
    render

    assert_select "form[action=?][method=?]", branches_path, "post" do
    end
  end
end
