module Rack::Utils
  def escape(s)
    CGI.escape(s.to_s)
  end
end
