require 'rails_helper'

RSpec.describe "laboratories/new", type: :view do
  before(:each) do
    assign(:laboratory, Laboratory.new(
      :name => "MyString",
      :departament => "MyString",
      :facilitador => "MyString"
    ))
  end

  it "renders new laboratory form" do
    render

    assert_select "form[action=?][method=?]", laboratories_path, "post" do

      assert_select "input#laboratory_name[name=?]", "laboratory[name]"

      assert_select "input#laboratory_departament[name=?]", "laboratory[departament]"

      assert_select "input#laboratory_facilitador[name=?]", "laboratory[facilitador]"
    end
  end
end
