require 'spec_helper'

describe "subjects/edit" do
  before(:each) do
    @subject = assign(:subject, stub_model(Subject,
      :name => "MyString",
      :neighborhood_id => 1,
      :type => ""
    ))
  end

  it "renders the edit subject form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", subject_path(@subject), "post" do
      assert_select "input#subject_name[name=?]", "subject[name]"
      assert_select "input#subject_neighborhood_id[name=?]", "subject[neighborhood_id]"
      assert_select "input#subject_type[name=?]", "subject[type]"
    end
  end
end
