module Blog
  module ShareHelper

    def addthis_javascript(options = {})
      (
      <<-JS
      <script type="text/javascript">
        var addthis_config = {"data_track_clickback":true};
      </script>
      <script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=ra-4dd2c24527d41a6b"></script>
      JS
      ).html_safe
    end

    def addthis_buttons(options = {})
      html_attrs = options.map { |k,v| "addthis:#{k}=\"#{v}\"" }.join(" ")

      (
      <<-HTML
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
    end

  end
end
