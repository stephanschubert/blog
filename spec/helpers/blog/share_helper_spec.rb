require 'spec_helper'

describe Blog::ShareHelper do

  describe "#addthis_buttons" do # ---------------------------------------------

    it "should be html safe" do
      html = helper.addthis_buttons
      html.should be_html_safe
    end

    it "should support custom 'addthis:' HTML attributes" do
      html = helper.addthis_buttons \
      :url => "http://custom.com/url",
      :title => "A custom title",
      :description => "A custom description"

      html.should have_tag \
      ".addthis_toolbox",
      "addthis:url" => "http://custom.com/url",
      "addthis:title" => "A custom title",
      "addthis:description" => "A custom description"
    end

  end

end
