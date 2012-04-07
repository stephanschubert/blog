Blog::Engine.routes.draw do

  # Backend ------------------------------------------------

  scope "backend", as: "backend" do
    root to: "posts#index"
    resources :posts
  end

  # Frontend -----------------------------------------------

  root to: "blogs#index"

  match '/archive' => 'blogs#archive', as: :archive

  match '/tags/:slug(/page/:page)' => 'blogs#posts_by_tag',
  as: :posts_by_tag,
  constraints: { }

  match '/feed.:format' => 'blogs#feed',
  as: :feed

  match '/:year(/:month)(/page/:page)' => 'blogs#posts_by_date',
  as: :posts_by_date,
  constraints: { year: /\d{4}/, month: /\d{2}/ }

  match '(/:year/:month)/:slug(/page/:page)' => 'blogs#slug',
  as: :slug,
  constraints: { year: /\d{4}/, month: /\d{2}/ }

  match '*shit', to: "blogs#routing_error"

end
