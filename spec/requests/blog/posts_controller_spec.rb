require 'spec_helper'

describe Blog::PostsController do

  describe "#index" do

    it "should render a template" do
      get "/blog"
      is_expected.to render_template("blog/blogs/index")
    end
  end
end
