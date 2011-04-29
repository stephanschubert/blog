Blog::Engine.routes.draw do

  root :to => "blogs#index"

  # Backend --------------------------------------------------------------------

  scope "backend", :as => "backend" do
    resources :posts
  end

end
