Blog::Engine.routes.draw do

  root :to => "posts#index"

  # Backend --------------------------------------------------------------------

  scope "backend" do
    resources :posts
  end

end
