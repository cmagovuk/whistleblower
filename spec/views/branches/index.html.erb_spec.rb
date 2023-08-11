require 'rails_helper'

RSpec.describe "branches/index", type: :view do
  before(:each) do
    assign(:branches, [
      Branch.create!(),
      Branch.create!()
    ])
  end

  it "renders a list of branches" do
    render
  end
end
