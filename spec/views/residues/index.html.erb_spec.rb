require 'rails_helper'

RSpec.describe "residues/index", type: :view do
  before(:each) do
    assign(:residues, [
      Residue.create!(
        :name => "Name",
        :laboratory => "Laboratory",
        :weight => 2,
        :collection => "Collection"
      ),
      Residue.create!(
        :name => "Name",
        :laboratory => "Laboratory",
        :weight => 2,
        :collection => "Collection"
      )
    ])
  end

  it "renders a list of residues" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Laboratory".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Collection".to_s, :count => 2
  end
end
