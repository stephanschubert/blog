module Blog
  module ShareHelper

    def addthis_javascript(options = {})
      options.reverse_merge! \
      :ga_id => (Settings.google.analytics.id rescue nil)

      addthis_google_analytics = if (ga_id = options.pluck(:ga_id))
        <<-JS
        data_ga_property: '#{ga_id}',
        data_track_clickback: true,
        JS
      end

      (
      <<-JS
      <script>
        var addthis_config = {
          #{addthis_google_analytics}
        }
        var addthis_share = {
          #{addthis_bitly_account}
          #{addthis_twitter_template}
        }
      </script>
      <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=#{Settings.blog.addthis.pubid}"></script>
      JS
      ).html_safe
    rescue
      nil
    end

    def addthis_bitly_account
      return if Settings.bitly.blank?
      <<-JS
      url_transforms : {
        shorten: {
          twitter: 'bitly'
        },
      },
      shorteners : {
        bitly : {
          username: '#{Settings.bitly.user_name}',
          apiKey: '#{Settings.bitly.api_key}'
        }
      },
      JS
    rescue
      nil
    end

    def addthis_twitter_template
      template = Settings.blog.addthis.templates.twitter
      <<-JS
      templates: {
        twitter: '#{template}'
      },
      JS
    rescue
      nil
    end


    def addthis_buttons(options = {})
      options.reverse_merge! \
      :layout => :compact

      layout = options.pluck(:layout)

      html_attrs = options.map { |k,v| "addthis:#{k}=\"#{v}\"" }.join(" ")

      if layout.to_s == "compact"
        (<<-HTML
        <div class="addthis_toolbox addthis_default_style" #{html_attrs}>
          <a class="addthis_button_preferred_1"></a>
          <a class="addthis_button_preferred_2"></a>
          <a class="addthis_button_preferred_3"></a>
          <a class="addthis_button_preferred_4"></a>
          <a class="addthis_button_compact"></a>
          <a class="addthis_counter addthis_bubble_style"></a>
        </div>
        HTML
        ).html_safe
      else
        # <a class="addthis_button_google_plusone"></a>
        tweet_attrs = {
          "tw:via" => Settings.twitter.user_name,
          "tw:related" => Settings.twitter.user_name
        }.map { |k,v|
          "#{k}=\"#{v}\""
        }.join(" ")

        (<<-HTML
        <div class="addthis_toolbox addthis_default_style" #{html_attrs}>
          <a class="addthis_counter addthis_pill_style"></a>
          <a class="addthis_button_tweet" #{tweet_attrs}"></a>
          <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
        </div>
        HTML
        ).html_safe
      end
    end

    def addthis_buttons_for_post(post, options = {})
      options.reverse_merge! \
      :url => public_post_url(post),
      :title => linify(untextilize(post.title)),
      :description => post.meta_description

      if options[:description].blank?
        text = truncate(untextilize(post.body), :length => 250, :words_only => true)
        options[:description] = text
      end

      addthis_buttons(options)
    end

    # GOOGLE PLUSONE +1 ------------------------------------

    def plusone_javascript
      (<<-JS
      <script>
        (function(d, t) {
          var g = d.createElement(t),
            	s = d.getElementsByTagName(t)[0];
          g.async = true;
          g.src = 'https://apis.google.com/js/plusone.js';
          s.parentNode.insertBefore(g, s);
        })(document, 'script');
     </script>
     JS
     ).html_safe
    end

    def plusone_button(options = {})
      options.reverse_merge! \
      :class       => "g-plusone",
      :lang        => I18n.locale,
      "data-size"  => :standard,
      "data-count" => true

      content_tag :div, options do
      end
    end

    def plusone_button_for_post(post, options = {})
      options.reverse_merge! \
      :href => public_post_url(post),
      "data-href" => public_post_url(post)

      plusone_button(options)
    end

  end
end
