def basic_auth(user, pass)
  encoded_login = ["#{user}:#{pass}"].pack("m*")
  page.driver.header 'Authorization', "Basic #{encoded_login}"
end
