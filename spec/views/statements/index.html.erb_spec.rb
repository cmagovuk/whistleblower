require 'rails_helper'

RSpec.describe "statements/index", type: :view do
  before(:each) do
    assign(:statements, [
      Statement.create!(),
      Statement.create!()
    ])
  end

  it "renders a list of statements" do
    render
  end
end
