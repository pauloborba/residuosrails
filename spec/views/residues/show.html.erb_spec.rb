require 'rails_helper'

RSpec.describe "residues/show", type: :view do
  before(:each) do
    @residue = assign(:residue, Residue.create!(
      :name => "Name",
      :laboratory => "Laboratory",
      :weight => 2,
      :collection => "Collection"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Laboratory/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Collection/)
  end
end
