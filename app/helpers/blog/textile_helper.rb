module Blog
  module TextileHelper

    # Automatically mark all textile'd strings as html-safe.
    def textilize(text, *options)
      text = process_adsense(text)
      text = process_figures(text)
      text = super(text, *options)
      text = nofollow_links(text)
      text.html_safe
    end

    # Textilize the input but don't wrap the result in a <p>aragraph.
    def textilize_without_paragraph(*args)
      textilize(*args).gsub(/^<p>|<\/p>$/, '').html_safe
    end

    # Remove textile formatting
    def untextilize(*args)
      text, args = *args

      text = remove_adsense(text)
      text = remove_figures(text)

      # Let textile do the work and just strip the tags afterwards.
      strip_tags(textilize(text, *args)).html_safe
    end

    def linify(s)
      s.gsub(/[\r\n\t]+/, ' ').strip
    end

    def nofollow_links(input)
      patterns   = Settings.blog.nofollow || []
      patterns   = patterns.map { |p| Regexp.escape(p) }.join("|")
      regex      = Regexp.new(patterns)
      href_regex = /href=(["'])[^"']*#{regex}[^"']*\1/

      input.dup.tap do |output|
        output.gsub!(href_regex) do |match|
          match.to_s + ' rel="nofollow"'
        end
      end
    end

    private # ----------------------------------------------

    def remove_adsense(text)
      text.gsub /!adsense(.+)$/, ""
    end

    def remove_figures(text)
      text.
        gsub(/!figure(.+)$/, "").
        gsub(/<figure[^>]*>(.*)<\/figure>/m, "")
    end

    def process_adsense(text)
      text.gsub /!adsense(.+)$/ do |match|
        begin
          options = JSON.parse($1).symbolize_keys
        rescue
          next
        end

        slot_name = options.pluck(:name)
        adsense_slot(slot_name, options)
      end
    end

    def process_figures(text)
      text.gsub /!figure(.+)$/ do |match|
        begin
          attrs = JSON.parse($1).symbolize_keys
        rescue
          next
        end

        <<-HTML
        <figure class="media #{attrs[:class]}">
          <div class="media-image">
            <img src="#{attrs[:src]}" title="#{attrs[:caption]}">
          </div>
          <figcaption class="media-body">
            <p>#{attrs[:caption]}</p>
            <p class="copyright">&copy; #{attrs[:author]}</p>
          </figcaption>
        </figure>
        HTML
      end
    end

  end
end
