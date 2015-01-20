require 'acceptance/acceptance_helper'

feature "Default blog behavior", %q{

  In order to have a great time
  As an user
  I want to read the blog

} do

  background do
    @one = F("blog/post",
             title: "One",
             body: "This is a body",
             published_at: Time.parse("2011/04/01"))

    @two = F("blog/post",
             title: "Two",
             body: "Second body",
             published_at: Time.parse("2011/04/03"))

    @draft = F("blog/post", published_at: nil)

    # Annoying.
    @host = "www.example.com"
  end

  scenario "View home page" do # ---------------------------
    visit '/blog'

    expect(page).to have_selector ".post-preview", count: 2
    expect(page).to have_post_preview @one
    expect(page).to have_post_preview @two
  end

  scenario "View single post" do # -------------------------
    # Should increase 'views' counter.
    expect(@one.views).to eq(0)
    visit '/blog/one'
    @one.reload
    expect(@one.views).to eq(1)

    expect(page).to have_selector ".post", count: 1
    expect(page).to have_post @one
    expect(page).to have_no_post @two
  end

  scenario "View single post w/ date" do # -----------------
    visit '/blog/2011/04/one'

    expect(page).to have_selector ".post", count: 1
    expect(page).to have_post @one
    expect(page).to have_no_post @two
  end

  scenario "View all posts published in a month" do # ------
    visit '/blog/2011/04'
    expect(page).to have_noindex_tag

    expect(page).to have_selector ".post-preview", count: 2
    expect(page).to have_post_preview @one
    expect(page).to have_post_preview @two
  end

  scenario "View all posts published in a year" do # -------
    three = F("blog/post", published_at: Time.parse("2010/12/28"))

    visit '/blog/2011'
    expect(page).to have_noindex_tag

    expect(page).to have_selector ".post-preview", count: 2
    expect(page).to have_post_preview @one
    expect(page).to have_post_preview @two
    expect(page).to have_no_post_preview three
  end

  scenario "View all posts tagged with ..." do # -----------
    @one.tags.create(:name => "General")
    @one.tags.create(:name => "Updates")
    @two.tags.create(:name => "General")

    visit '/blog/tags/general'
    expect(page).to have_noindex_tag

    expect(page).to have_selector ".post-preview", count: 2
    expect(page).to have_post_preview @one
    expect(page).to have_post_preview @two

    visit '/blog/tags/updates'
    expect(page).to have_noindex_tag

    expect(page).to have_selector ".post-preview", count: 1
    expect(page).to have_post_preview @one
  end

  scenario "Textilized post content" do # ------------------
    post = F("blog/post",
      title: "A crazy cool new post",
      body:  "This is a body",
      published_at: 1.day.ago
    )

    visit '/blog/a-crazy-cool-new-post'

    within ".entry-content" do
      expect(page.html).to match(/<p>This is a body<\/p>/)
    end
  end

  scenario "Latest posts" do # -----------------------------
    visit '/blog'

    within :css, "#latest-posts" do
      path = public_post_path(@one)
      expect(page).to have_selector "a[href$='#{path}']"

      path = public_post_path(@two)
      expect(page).to have_selector "a[href$='#{path}']"
    end
  end

  scenario "Tags overview" do # ----------------------------
    post = F("blog/post", :published_at => 1.day.ago)
    post.tags.create :name => "General"
    post.tags.create :name => "Updates"

    visit '/blog'

    within :css, "#all-tags" do
      expect(page).to have_selector "a[href$='/general']"
      expect(page).to have_selector "a[href$='/updates']"
    end
  end

  scenario "Auto-Discovery Links" do # ---------------------
    visit '/blog'

    %w(rss atom).each do |type|
      expect(page).to have_selector(
        "link[type='application/#{type}+xml'][rel='alternate'][href$='/feed.#{type}']", visible: false
      )
    end
  end

  scenario "Visible Feed Links" do # -----------------------
    visit '/blog'

    within :css, "#feeds" do
      %w(rss atom).each do |type|
        expect(page).to have_selector "a[href$='/feed.#{type}']"
      end
    end
  end

  scenario "View RSS Feed" do # ----------------------------
    visit '/blog/feed.rss'

    within :css, "rss[version='2.0']" do
      within :css, "channel" do
        expect(page).to have_selector "title"
        expect(page).to have_selector "description"
        expect(page).to have_selector "link"

        [ @two, @one ].each_with_index do |post, index|
          within :css, "item:#{index == 0 ? 'first' : 'last'}" do

            within :css, "title" do
              expect(page).to have_content(post.title)
            end

            expect(page).to have_selector "description" # TODO
            expect(page).to have_selector "link" #, :text => public_post_url(post, :host => @host)

            within :css, "guid" do
              expect(page).to have_content(public_post_url(post, host: @host))
            end

            within :css, "pubdate" do
              expect(page).to have_content(post.published_at.to_s(:rfc822))
            end

            post.tags.each do |tag|
              expect(page).to have_selector "category", text: tag.name
            end
          end
        end
      end
    end
  end

  scenario "View ATOM Feed" do # ---------------------------
    visit '/blog/feed.atom'

    within :css, "feed" do
      expect(page).to have_selector "id"
      expect(page).to have_selector "title"
      expect(page).to have_selector "updated"

      [ @two, @one ].each_with_index do |post, index|
        within :css, "entry:#{index == 0 ? 'first' : 'last'}" do
          expect(page).to have_selector "id"

          within :css, "published" do
            expect(page).to have_content(post.published_at.iso8601)
          end

          within :css, "updated" do
            expect(page).to have_content(post.updated_at.iso8601)
          end

          within :css, "title" do
            expect(page).to have_content(post.title)
          end

          expect(page).to have_selector "content[type='html']" # TODO

          url = public_post_url(post, host: @host)
          expect(page).to have_selector "link[href='#{url}']"

          post.tags.each do |tag|
            expect(page).to have_selector "category", text: tag.name
          end
        end
      end
    end
  end

  scenario "View archive" do # -----------------------------
    one   = F("blog/post", published_at: Time.parse("2009/02/01"))
    two   = F("blog/post", published_at: Time.parse("2010/04/03"))
    three = F("blog/post", published_at: Time.parse("2011/08/05"))

    visit '/blog/archive'
    expect(page).to have_noindex_tag

    expect(page).to have_link_to_post one
    expect(page).to have_link_to_post two
    expect(page).to have_link_to_post three
  end

  scenario "One post with matching slug alias" do
    one = F('blog/post', slug_aliases: ['a-tale'], published_at: 2.days.ago)

    visit '/blog/a-tale'
    expect(page).to have_post(one)
  end

  scenario "Two posts where one slug contains the other one" do
    one = F('blog/post', title: 'A tale', published_at: 2.days.ago)
    two = F('blog/post', title: 'A tale (Part 2)', published_at: 1.day.ago)

    visit '/blog/a-tale'
    expect(page).to have_post(one)
  end

  scenario "Three posts where two have a similar slug and the third one a matching slug alias" do
    one   = F('blog/post', title: 'A tale (Part 1)', published_at: 3.days.ago)
    two   = F('blog/post', title: 'A tale (Part 2)', published_at: 2.days.ago)
    three = F('blog/post', slug_aliases: ['a-tale'], published_at: 1.day.ago)

    visit '/blog/a-tale'
    expect(page).to have_post(three)
  end



  # FIXME Not working - see spec/acceptance/support/capybara/caching for details.
  # scenario "View updated post" do # ------------------------
  #   post = F("blog/post", body: "First draft.", published_at: 1.day.ago)

  #   visit public_post_path(post)
  #   page.should have_content "First draft."

  #   post.body = "Second draft."
  #   post.save

  #   visit public_post_path(post)
  #   page.should have_content "Second draft."
  # end

end
