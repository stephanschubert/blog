Blog::Engine.routes.draw do

  # Frontend -------------------------------------------------------------------

  root :to => "blogs#index"
  match '/:id' => 'blogs#post', :as => :post

  # Backend --------------------------------------------------------------------

  scope "backend", :as => "backend" do
    resources :posts
  end

end
