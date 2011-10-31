atom_feed :language => I18n.locale, :root_url => blog.root_url do |feed|
  feed.title t("blog.feed.atom.title")
  feed.updated @posts.first.published_at

  @posts.each do |post|
    published = post.published_at
    updated   = post.updated_at < published ? published : post.updated_at

    feed.entry(post, url: public_post_url(post), published: published, updated: updated) do |entry|
      entry.title     post.title
      entry.content   textilize(post.body), type: :html

      post.tags.each do |tag|
        entry.category tag.name, domain: blog.posts_by_tag_url(tag)
      end
    end
  end
end
