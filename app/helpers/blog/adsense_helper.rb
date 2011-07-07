module Blog
  module AdsenseHelper

    def adsense_javascript
      '<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>'.html_safe
    end

    def adsense_block(options = {}, &block)
      options.reverse_merge! \
      :class  => "adsense",
      :client => (Settings.blog.adsense.client rescue nil)

      client, slot, width, height =
        options.pluck(:client, :slot, :height, :width)

      content_tag :div, options do
        (<<-ADSENSE
        <script>
          google_ad_client = "#{client}";
          google_ad_slot = "#{slot}";
          google_ad_width = #{width};
          google_ad_height = #{height};
        </script>
        ADSENSE
        ) + adsense_javascript
      end
    end

  end
end
