Blog::Engine.routes.draw do

  # Frontend -------------------------------------------------------------------

  root :to => "blogs#index"

  # match '/:year/:month/:id' => 'blogs#post',
  # :as => :post_with_date,
  # :constraints =>

  match '(/:year/:month)/:id' => 'blogs#post',
  :as => :post,
  :constraints => { :year => /\d{4}/, :month => /\d{2}/ }

  # Backend --------------------------------------------------------------------

  scope "backend", :as => "backend" do
    resources :posts
  end

end
