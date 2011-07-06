module Blog
  module FacebookHelper

    Facebook_Like_Button_Layouts = {
      :standard     => { :width => 450, :height => 35 },
      :button_count => { :width => 120, :height => 20 },
      :box_count    => { :width => 55,  :height => 65 },
    }.with_indifferent_access

    def facebook_like_button(url, options = {})
      options.reverse_merge! \
      :layout  => "button_count",
      :url     => url

      options.reverse_merge! \
      :width   => Facebook_Like_Button_Layouts[options.layout].width,
      :height  => Facebook_Like_Button_Layouts[options.layout].height

      url, layout, width, height =
        options.pluck(:url, :layout, :width, :height)

      (<<-FACEBOOK
        <iframe src="http://www.facebook.com/plugins/like.php?href=#{url}&amp;layout=#{layout}&amp;show_faces=true&amp;width=#{width}&amp;action=like&amp;font=arial&amp;colorscheme=light&amp;height=20" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#{width}px; height:#{height}px;" allowTransparency="true"></iframe>
      FACEBOOK
      ).html_safe
    end

    def facebook_like_button_for_post(post, options = {})
      facebook_like_button(public_post_url(post), options)
    end

  end
end
