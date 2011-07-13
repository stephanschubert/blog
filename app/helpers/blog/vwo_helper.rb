module Blog
  module VwoHelper

    # TODO Make it customizable
    def vwo_javascript
      (<<-VWO
<!-- Start Visual Website Optimizer Asynchronous Code -->
<script type='text/javascript'>
var _vis_opt_account_id = 3882;
var _vis_opt_abort_tolerance = 3000; // Time allowed in ms before the test aborts.
var _vis_opt_use_existing_jquery = true; // Use jquery from the page itself?
// DO NOT EDIT BELOW THIS LINE
var _vis_start_time=(new Date()).getTime();var _vis_opt_finished=false;var _vis_opt_load_script=function(a){var b=document.createElement('script');b.src=a;b.type='text/javascript';b.innerText;b.onerror=function(){_vis_opt_finish()};document.getElementsByTagName('head')[0].appendChild(b)};var _vis_opt_protocol=(('https:'==document.location.protocol)?'https://':'http://');var _vis_opt_finish=function(){_vis_opt_finished=true;var a=document.getElementById('_vis_opt_path_hides');if(a){a.parentNode.removeChild(a)}};setTimeout(_vis_opt_finish,_vis_opt_abort_tolerance);_vis_opt_load_script('//dev.visualwebsiteoptimizer.com/jsa.php?a='+_vis_opt_account_id+'&url='+encodeURIComponent(document.URL)+'&random='+Math.random());var _vis_opt_hide=function(){var a=document.createElement('style');a.setAttribute('id','_vis_opt_path_hides');a.setAttribute('type','text/css');var b='body {display: none; }';if(a.styleSheet){a.styleSheet.cssText=b}else{var c=document.createTextNode(b);a.appendChild(c)}var h=document.getElementsByTagName('head')[0];h.appendChild(a)};_vis_opt_hide();
</script>
<!-- End Visual Website Optimizer Asynchronous Code -->
      VWO
      ).html_safe
    end

  end
end
