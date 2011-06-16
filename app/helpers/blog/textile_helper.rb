module Blog
  module TextileHelper

    # Automatically mark all textile'd strings as html-safe.
    def textilize(*args)
      super(*args).html_safe
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

  end
end
