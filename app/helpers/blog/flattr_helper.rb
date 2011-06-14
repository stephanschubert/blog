module Blog
  module FlattrHelper

    def flattr_javascript
      (<<-JS
      <script type="text/javascript">
      /* <![CDATA[ */
      (function() {
        var s = document.createElement('script'), t = document.getElementsByTagName('script')[0];
        s.type = 'text/javascript';
        s.async = true;
        s.src = 'http://api.flattr.com/js/0.6/load.js?mode=auto';
        t.parentNode.insertBefore(s, t);
      })();
      /* ]]> */
      </script>
      JS
      ).html_safe
    end

    def flattr_button_for_post(post, options = {})
      options.reverse_merge! \
      :text  => truncate(untextilize(post.body), :length => 500, :words_only => true),
      :url   => public_post_url(post),
      :title => untextilize(post.title)
      # TODO "data-flattr-tags"

      text, url = options.pluck(:text, :url)
      flattr_button(text, url, options)
    end

    def flattr_button(text, url, options = {})
      return if Settings.flattr.blank?

      options.reverse_merge! \
      :text  => text,
      :title => text,
      :url   => url,
      :class => "FlattrButton",
      :style => "display:none",
      :lang  => I18n.locale,

      "data-flattr-uid"      => Settings.flattr.uid,
      "data-flattr-button"   => "compact",
      "data-flattr-category" => "text"

      text, url = options.pluck(:text, :url)
      link_to text, url, options
    end

  end
end
