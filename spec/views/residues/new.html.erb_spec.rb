require 'rails_helper'

RSpec.describe "residues/new", type: :view do
  before(:each) do
    assign(:residue, Residue.new(
      :name => "MyString",
      :laboratory => "MyString",
      :weight => 1,
      :collection => "MyString"
    ))
  end

  it "renders new residue form" do
    render

    assert_select "form[action=?][method=?]", residues_path, "post" do

      assert_select "input#residue_name[name=?]", "residue[name]"

      assert_select "input#residue_laboratory[name=?]", "residue[laboratory]"

      assert_select "input#residue_weight[name=?]", "residue[weight]"

      assert_select "input#residue_collection[name=?]", "residue[collection]"
    end
  end
end
