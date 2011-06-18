module Blog
  module TagsHelper

    def linked_tags_as_sentence(tags)
      links     = tags.map { |tag| link_to_tag(tag) }
      sentence  = links.slice(0..-2).join(", ")
      sentence << " und " << links.last
      sentence.html_safe
    end

  end
end
