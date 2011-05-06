atom_feed :language => I18n.locale, :root_url => blog.root_url do |feed|
  feed.title t("blog.feed.atom.title")
  feed.updated @posts.first.published_at

  @posts.each do |post|
    feed.entry(post, :url => public_post_url(post)) do |entry|
      entry.title     post.title
      entry.content   textilize(post.body), :type => :html
      entry.published post.published_at
      entry.updated   post.published_at

      post.tags.each do |tag|
        entry.category tag.name, :domain => blog.posts_by_tag_url(tag)
      end
    end
  end
end
