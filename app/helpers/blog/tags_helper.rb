module Blog
  module TagsHelper

    # Returns a link to tag/category according to the hAtom spec.
    def link_to_tag(tag, options = {}, &block)
      options.reverse_merge! \
      :rel   => "tag",
      :title => tag.name,
      :text  => tag.name,
      :url   => public_tag_path(tag.slug)

      text, url = options.pluck(:text, :url)
      text = capture(&block) if block_given?

      link_to url, options do
        # The extra <span> is just for styling purposes.
        content_tag :span, text
      end
    end

    def linked_tags_as_sentence(tags)
      links     = tags.map { |tag| link_to_tag(tag) }
      sentence  = links.slice(0..-2).join(", ")
      sentence << " und " << links.last
      sentence.html_safe
    end

  end
end
