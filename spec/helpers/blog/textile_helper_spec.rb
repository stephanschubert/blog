# -*- coding: utf-8 -*-
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

    it "should remove markup from !adsense" do
      textiled = <<-TXT
First paragraph.

!adsense{"name": "banner", "class": ""}

Second paragraph.
TXT
      cleaned = helper.untextilize(textiled)
      cleaned.should == "First paragraph.\nSecond paragraph."
    end

    it "should remove markup from !figure" do
      textiled = <<-TXT
First paragraph.

!figure{"class": "photo", "src": "http://some.host/images/blah.jpg", "author": "unknown", "caption": "some caption"}

Second paragraph.
TXT
      cleaned = helper.untextilize(textiled)
      cleaned.should == "First paragraph.\nSecond paragraph."
    end

    it "should remove <figure> markup" do
      textiled = <<-TXT
First paragraph.

<figure class="book amazon">
  <div class="img"><a href="http://www.amazon.de/gp/product/0452285755/ref=as_li_ss_il?ie=UTF8&tag=stevepavlina-21&linkCode=as2&camp=1638&creative=19454&creativeASIN=0452285755"><img border="0" src="http://ws.assoc-amazon.de/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=0452285755&MarketPlace=DE&ID=AsinImage&WS=1&tag=stevepavlina-21&ServiceVersion=20070822" ></a><img src="http://www.assoc-amazon.de/e/ir?t=stevepavlina-21&l=as2&o=3&a=0452285755" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /></div>
  <figcaption>
    <p>"How to Be a Superhero":http://www.amazon.de/gp/product/0452285755/ref=as_li_ss_tl?ie=UTF8&tag=stevepavlina-21&linkCode=as2&camp=1638&creative=19454&creativeASIN=0452285755 von Barry Neville</p>
    <p>Nur in Englisch verf¸gbar</p>
  </figcaption>
</figure>

Second paragraph.
TXT
      cleaned = helper.untextilize(textiled)
      cleaned.should == "First paragraph.\nSecond paragraph."
    end

    it "should be html-safe" do
      textiled = "The *quick* _brown fox_ <em>jumps</em> over the lazy dog."
      cleaned  = helper.untextilize(textiled)
      cleaned.should be_html_safe
    end

  end

end
