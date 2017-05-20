require 'rails_helper'

RSpec.describe "residues/edit", type: :view do
  before(:each) do
    @residue = assign(:residue, Residue.create!(
      :name => "MyString",
      :laboratory => "MyString",
      :weight => 1,
      :collection => "MyString"
    ))
  end

  it "renders the edit residue form" do
    render

    assert_select "form[action=?][method=?]", residue_path(@residue), "post" do

      assert_select "input#residue_name[name=?]", "residue[name]"

      assert_select "input#residue_laboratory[name=?]", "residue[laboratory]"

      assert_select "input#residue_weight[name=?]", "residue[weight]"

      assert_select "input#residue_collection[name=?]", "residue[collection]"
    end
  end
end
