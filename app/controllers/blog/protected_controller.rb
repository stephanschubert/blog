module Blog
  class ProtectedController < SessionsController
    before_filter :require_login

    layout "blog/backend"

    private # ----------------------------------------------

    Users = {
      "baktinet" => "6bd5069e47fc68f2"
    }

    def require_login
      authenticate_or_request_with_http_basic do |username, password|
        if Users[username] == password
          session[:user_id] = 1
        end
      end
    end

  end
end
