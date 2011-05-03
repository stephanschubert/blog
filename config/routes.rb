Blog::Engine.routes.draw do

  # Frontend -------------------------------------------------------------------

  root :to => "blogs#index"

  match '/:year(/:month)' => 'blogs#posts_by_date',
  :as => :posts_by_date,
  :constraints => { :year => /\d{4}/, :month => /\d{2}/ }

  match '(/:year/:month)/:id' => 'blogs#post',
  :as => :post,
  :constraints => { :year => /\d{4}/, :month => /\d{2}/ }

  match '/tags/:id' => 'blogs#posts_by_tag',
  :as => :posts_by_tag

  # Backend --------------------------------------------------------------------

  scope "backend", :as => "backend" do
    resources :posts
  end

end
