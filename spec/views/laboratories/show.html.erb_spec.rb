require 'rails_helper'

RSpec.describe "laboratories/show", type: :view do
  before(:each) do
    @laboratory = assign(:laboratory, Laboratory.create!(
      :name => "Name",
      :departament => "Departament",
      :facilitador => "Facilitador"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Departament/)
    expect(rendered).to match(/Facilitador/)
  end
end
