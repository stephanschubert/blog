require 'spec_helper'

describe Blog::TextileHelper do

  describe "#textilize" do # -------------------------------

    it "should return a html-safe tring" do
      result = helper.textilize("Some text")
      result.should be_html_safe
    end

    it "should support the 'figure' extension" do
      html = helper.textilize <<-TXT
!figure{"class":"photo", "src":"/images/blah.jpg", "caption":"A caption.","author":"Max Test"}
TXT

      Capybara.string(html).find("figure[class='media photo']").tap do |f|
        f.find("*[class='media-image']").tap do |div|
          div.should have_selector("img[src='/images/blah.jpg'][title='A caption.']")
        end

        f.find("figcaption[class='media-body']").tap do |caption|
          caption.should have_content("A caption.")
          caption.should have_content("Max Test")
        end
      end
    end

    # it "should support the 'adsense' extension" do
    #   html = helper.textilize <<-TXT
    #     !adsense{"class": "left", "name": "banner"}
    #   TXT

    #   Capybara.string(html).find("div[class='adsense banner left']").tap do |div|
    #     div.should have_selector('script')
    #   end
    # end

  end

  describe "#textilize_without_paragraph" do # -------------

    it "should return an result not wrapped in <p>" do
      result = helper.textilize_without_paragraph("Some text")
      result.should_not match(/^<p>|<\/p>$/)
    end

    it "should be html-safe" do
      result = helper.textilize_without_paragraph("Some text")
      result.should be_html_safe
    end

  end

  describe "#untextilize" do # -----------------------------

    it "should return the cleaned string" do
      textiled = "The *quick* _brown fox_ <em>jumps</em> over the lazy dog."
      cleaned  = helper.untextilize(textiled)
      cleaned.should == "The quick brown fox jumps over the lazy dog."
    end

    it "should be html-safe" do
      textiled = "The *quick* _brown fox_ <em>jumps</em> over the lazy dog."
      cleaned  = helper.untextilize(textiled)
      cleaned.should be_html_safe
    end

  end

end
