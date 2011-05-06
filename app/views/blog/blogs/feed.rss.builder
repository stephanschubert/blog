xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.language I18n.locale.to_s
    xml.title t("blog.feed.rss.title")
    xml.description t("blog.feed.rss.description")
    xml.link blog.root_url

    @posts.each do |post|
      xml.item do
        xml.title   post.title
        xml.description textilize(post.body), :type => :html

        xml.link    public_post_url(post)
        xml.guid    public_post_url(post)
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.author  post.user.name if post.user

        post.tags.each do |tag|
          xml.category tag.name, :domain => blog.posts_by_tag_url(tag)
        end
      end
    end
  end
end
