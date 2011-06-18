module Blog
  module AdsenseHelper

    def adsense_javascript
      '<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>'.html_safe
    end

    def adsense_block(options = {}, &block)
      options.reverse_merge! \
      :class => "adsense"

      content_tag :div, options do
        capture(&block) + adsense_javascript
      end
    end

  end
end
