module Blog
  module DisqusHelper

    def comments_enabled?
      Settings.blog.disqus.enabled
    rescue
      false
    end

    def disqus_identifier_for(post, options = {})
      options.reverse_merge! \
      :shortname => Settings.blog.disqus.shortname

      "#{options[:shortname]}-#{post.id}"
    end

    def link_to_comments(post, options = {}, &block)
      options.reverse_merge! \
      :url   => public_post_url(post, :anchor => "disqus_thread"),
      :text  => t("blog.comments.link.text"),
      :title => t("blog.comments.link.title"),
      :"data-disqus-identifier" => disqus_identifier_for(post)

      link_to_post(post, options, &block)
    end

    def disqus_thread_javascript_for(post, options = {})
      options.reverse_merge! \
      :shortname  => Settings.blog.disqus.shortname,
      :identifier => disqus_identifier_for(post),
      :url        => public_post_url(post)

      (<<-HTML
      <div id="disqus_thread"></div>
      <script type="text/javascript">
        #{"var disqus_developer = 1;" unless Rails.env.production?}
        var disqus_shortname = '#{options[:shortname]}';
        var disqus_identifier = '#{options[:identifier]}';
        var disqus_url = '#{options[:url]}';

        (function() {
          var dsq = document.createElement('script');
          dsq.type = 'text/javascript';
          dsq.async = true;
          dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
          (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
      </script>
      <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
      HTML
      ).html_safe
    end

    def disqus_comment_count_javascript(options = {})
      options.reverse_merge! \
      :shortname => Settings.blog.disqus.shortname

      (<<-HTML
      <script type="text/javascript">
        #{"var disqus_developer = 1;" unless Rails.env.production?}
        var disqus_shortname = '#{options[:shortname]}';

        (function () {
          var s = document.createElement('script');
          s.async = true;
          s.type = 'text/javascript';
          s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
          (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
        }());
      </script>
      HTML
      ).html_safe
    end

  end
end
