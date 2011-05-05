module Blog
  module TrackingHelper

    def tracking_enabled?
      Rails.env.production?
    end

    def track_with_google_analytics
      return unless tracking_enabled?

      id     = Settings.google.analytics.id
      domain = Settings.google.analytics.domain

      output = <<-GOOGLE
<script>
  var _gaq = [
      ['_setAccount', '#{id}']
    , ['_gat._anonymizeIp']
    , ['_setDomainName', '#{domain}']
    , ['_trackPageview']
    , ['_trackPageLoadTime']
  ];

  (function(d, t) {
    var g = d.createElement(t),
        s = d.getElementsByTagName(t)[0];
    g.async = 1;
    g.src = ('https:' == location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    s.parentNode.insertBefore(g, s);
  })(document, 'script');
</script>
GOOGLE
      output.html_safe
    end

    def track_with_google_webmasters_tools
      key = Settings.google.webmaster_tools.site_verification
      tag "meta", :name => "google-site-verification", :content => key
    rescue => e
      # Dont fail if the configuration is missing.
    end

  end
end
