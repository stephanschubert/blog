module Blog
  module AdsenseHelper

    def adsense_javascript
      '<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>'.html_safe
    end

    def adsense_block(options = {})
      options.reverse_merge! \
      :client => (Settings.blog.adsense.client rescue nil)

      client, name, slot, width, height =
        options.pluck(:client, :name, :slot, :width, :height)

      options[:class] = merge_css("adsense", name)

      content_tag :div, options do
        (<<-ADSENSE
        <script>
          google_ad_client = "#{client}";
          google_ad_slot = "#{slot}";
          google_ad_width = #{width};
          google_ad_height = #{height};
        </script>
        ADSENSE
        ).html_safe + adsense_javascript
      end
    end

    def adsense_slot(name, options = {})
      options.reverse_merge! \
      :name   => name,
      :slot   => Settings.blog.adsense.send(name).slot,
      :width  => Settings.blog.adsense.send(name).width,
      :height => Settings.blog.adsense.send(name).height

      adsense_block(options)
    end

    def inject_adsense(html, options = {})
      options.reverse_merge! \
      :marker => "[ADSENSE]",
      :delta  => html.size / 3 # Roughly

      last_offset = 0
      offsets     = []

      html.scan('</p>') do |match|
        pos = $~.pre_match.size + match.size

        if pos >= last_offset + options[:delta]
          offsets << pos
          last_offset += options[:delta]
        end
      end

      offsets.slice(0,2).each_with_index do |offset, index|
        marker = options[:marker]
        offset = offset + (index * marker.size)
        html   = html.insert offset, marker
      end

      html = html.gsub options[:marker], adsense_slot(:banner)
      html = adsense_slot(:large_rect) + html.html_safe
      html.html_safe
    end

    def adsense_section(options = {}, &block)
      if options[:ignore]
        attrs = '(weight=ignore)'
      end

      "<!-- google_ad_section_start#{attrs} -->".html_safe +
      capture(&block) +
      "<!-- google_ad_section_end -->".html_safe
    end

  end
end
