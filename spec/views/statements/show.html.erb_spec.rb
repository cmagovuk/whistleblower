require 'rails_helper'

RSpec.describe "statements/show", type: :view do
  before(:each) do
    @statement = assign(:statement, Statement.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
