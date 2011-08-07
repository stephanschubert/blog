module Blog
  module TextileHelper

    # Automatically mark all textile'd strings as html-safe.
    def textilize(text, *options)
      text = process_figures(text)
      super(text, *options).html_safe
    end

    # Textilize the input but don't wrap the result in a <p>aragraph.
    def textilize_without_paragraph(*args)
      textilize(*args).gsub(/^<p>|<\/p>$/, '').html_safe
    end

    # Remove textile formatting
    def untextilize(*args)
      # Let textile do the work and just strip the tags afterwards.
      strip_tags(textilize(*args))
    end

    def linify(s)
      s.gsub(/[\r\n\t]+/, ' ').strip
    end

    private # ----------------------------------------------

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
