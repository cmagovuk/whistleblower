require 'rails_helper'

RSpec.describe "branches/show", type: :view do
  before(:each) do
    @branch = assign(:branch, Branch.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
