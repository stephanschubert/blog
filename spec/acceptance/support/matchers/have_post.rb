RSpec::Matchers.define :have_post do |post|
  match do |page|
    within :css, "#post-#{post.id}.hentry.post" do

      # The post's title
      within ".entry-title a[rel='bookmark']" do
        textilized = textilize_without_paragraph(post.title)
        page.should have_content(textilized)
      end

      # The publication date
      humanized_date = l(post.published_at, format: :standard)
      within :css, ".entry-published" do
        page.should have_content(humanized_date)
      end

      # The post's author
      # TODO Remove rescue clause
      name = post.user.name rescue "Admin"
      within :css, ".entry-author" do
        page.should have_content(name)
      end

      # The post's tags/categories
      unless post.tags.blank?
        within :css, ".entry-tags" do
          post.tags.each do |tag|
            path = tag.slug
            name = tag.name

            within :css, "a[href$='#{path}'][rel='tag'][title='#{name}']" do
              page.should have_content(name)
            end
          end
        end
      end

      # The post's content
      within :css, ".entry-content" do
        page.should have_content(post.body)
      end

    end
  end
end

RSpec::Matchers.define :have_post_preview do |post|
  match do |page|
    within(:css, "#post-#{post.id}.post-preview") do

      # The title (textilized + linked)
      post_title = textilize_without_paragraph(post.title)
      within :css, ".entry-title" do
        page.should have_selector "a[rel='bookmark']", text: post_title
      end

      # The publication date
      humanized_date = l(post.published_at, format: :short)
      within :css, ".entry-published" do
        page.should have_content(humanized_date)
      end

      # The excerpt
      # TODO How to determine it's length?
      page.should have_selector ".entry-excerpt"
    end
  end
end

RSpec::Matchers.define :have_no_post do |post|
  match do |page|
    page.should have_no_selector("#post-#{post.id}.hentry.post")
  end
end

RSpec::Matchers.define :have_no_post_preview do |post|
  match do |page|
    page.should have_no_selector("#post-#{post.id}.hentry.post-preview")
  end
end

RSpec::Matchers.define :have_link_to_post do |post|
  match do |page|
    path = post.slug
    page.should have_selector "a[href$='#{path}']"
  end
end
