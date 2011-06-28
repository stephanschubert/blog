module Blog
  module FeedHelper

    def rss_feed_url
      Settings.app.feeds.rss
    rescue
      blog.feed_path(:format => :rss)
    end

    def atom_feed_url
      Settings.app.feeds.atom
    rescue
      blog.feed_path(:format => :atom)
    end

  end
end
