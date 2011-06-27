# -*- coding: utf-8 -*-
module Blog
  module PaypalHelper

    # TODO Make customizable..
    def paypal_donate_button
      (<<-PAYPAL
      <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
        <input type="hidden" name="cmd" value="_s-xclick">
        <input type="hidden" name="hosted_button_id" value="TEDZ7ME4JUBXG">
        <input type="image" src="https://www.paypalobjects.com/WEBSCR-640-20110401-1/de_DE/DE/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="Jetzt einfach, schnell und sicher online bezahlen – mit PayPal.">
        <img alt="" border="0" src="https://www.paypalobjects.com/WEBSCR-640-20110401-1/de_DE/i/scr/pixel.gif" width="1" height="1">
      </form>
      PAYPAL
      ).html_safe
    end

  end
end
