require 'spec_helper'

describe Blog::PostsController do

  describe "#index" do # -------------------------------------------------------

    it "should render a template" do
      get "/blog"
      should render_template("posts/index")
    end

  end

end
