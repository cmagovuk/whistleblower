require 'rails_helper'

RSpec.describe "statements/new", type: :view do
  before(:each) do
    assign(:statement, Statement.new())
  end

  it "renders new statement form" do
    render

    assert_select "form[action=?][method=?]", statements_path, "post" do
    end
  end
end
