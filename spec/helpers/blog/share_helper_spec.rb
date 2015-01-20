require 'spec_helper'

describe Blog::ShareHelper do

  describe "#addthis_buttons" do # ---------------------------------------------

    it "should be html safe" do
      html = helper.addthis_buttons
      expect(html).to be_html_safe
    end

    it "should support custom 'addthis:' HTML attributes" do
      html = helper.addthis_buttons \
      :url => "http://custom.com/url",
      :title => "A custom title",
      :description => "A custom description"

      expect(html).to have_tag \
      ".addthis_toolbox",
      "addthis:url" => "http://custom.com/url",
      "addthis:title" => "A custom title",
      "addthis:description" => "A custom description"
    end

  end

  describe "#plusone_button" do # ----------------------------------------------

    it "should return least valid markup" do
      html = helper.plusone_button
      expect(html).to have_tag "div.g-plusone[data-size=standard][data-count=true]"
    end

    it "should set the 'lang' attribute" do
      locale = I18n.locale
      html   = helper.plusone_button

      expect(html).to have_tag "div.g-plusone[lang=#{locale}]"
    end

  end

  describe "#plusone_button_for_post" do # ------------------------------------

    # TODO Doesn't work because we can't access 'public_post_url' helper!?
    #
    # it "should return valid markup w/ href matching the post's url" do
    #   post = F("blog/post", :slug => "a-post", :published_at => 1.day.ago)
    #   html = helper.plusone_button_for_post(post)

    #   html.should have_tag "div.g-plusone[href$=/a-post]"
    # end

  end

end
