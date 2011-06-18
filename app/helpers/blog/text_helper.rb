module Blog
  module TextHelper

    # A better truncate which respects the word boundaries
    # if the option +words_only+ is true.
    #
    def truncate(text, options = {})
      options.reverse_merge! \
      :omission => "..."

      # Call the original truncate
      shorty = super(text, options)
      shorty = shorty.to_str # Ensure we don't get a html-safe string

      # Remove the broken/impartial word at the end of the string
      if options[:words_only]
        omission   = options[:omission]
        broken_word = /([^\s]+)#{omission}\Z/

        if shorty =~ broken_word
          shorty.sub!(broken_word, omission)
        end
      end

      shorty
    end

  end
end
