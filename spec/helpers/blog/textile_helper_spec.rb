require 'spec_helper'

describe Blog::TextileHelper do

  describe "#textilize" do # ---------------------------------------------------

    it "should return a html-safe tring" do
      result = helper.textilize("Some text")
      result.should be_html_safe
    end

  end

  describe "#textilize_without_paragraph" do # ---------------------------------

    it "should return an result not wrapped in <p>" do
      result = helper.textilize_without_paragraph("Some text")
      result.should_not match(/^<p>|<\/p>$/)
    end

  end

  describe "#untextilize" do # -------------------------------------------------

    it "should return the cleaned string" do
      textiled = "The *quick* _brown fox_ <em>jumps</em> over the lazy dog."
      cleaned  = helper.untextilize(textiled)
      cleaned.should == "The quick brown fox jumps over the lazy dog."
    end

  end

end
