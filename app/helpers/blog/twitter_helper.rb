module Blog
  module TwitterHelper

    def twitter_javascript
      (<<-JS
      <script>
        (function(doc,name) {
          var e = doc.createElement(name),
              s = doc.getElementsByTagName(name)[0];

          e.async = true;
          e.src   = 'http://platform.twitter.com/widgets.js';
          s.parentNode.insertBefore(e, s);
        })(document, 'script');
      </script>
      JS
      ).html_safe
    end

    def tweet_button(url, text, options = {})
      options.reverse_merge! \
      :class       => "twitter-share-button",
      :url         => "http://twitter.com/share",
      :text        => "Tweet",
      "data-url"   => url,
      "data-count" => "vertical",
      "data-via"   => (Settings.twitter.account rescue nil),
      "data-text"  => text

      text, url = options.pluck(:text, :url)
      link_to text, url, options
    end

    def tweet_button_for_post(post, options = {})
      options.reverse_merge! \
      "data-url"  => public_post_url(post),
      "data-text" => untextilize(post.title)

      text, url = options.pluck(:text, :url)
      tweet_button(text, url, options)
    end

  end
end
