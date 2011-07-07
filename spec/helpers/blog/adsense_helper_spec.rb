require 'spec_helper'

describe Blog::AdsenseHelper do

  describe "#adsense_javascript" do # ----------------------

    it "should return a <script> loading 'show_ads.js'" do
      html = helper.adsense_javascript
      html.should == '<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>'
    end

  end

end
