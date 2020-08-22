Rails.application.routes.draw do
  delete '/admin/comments/clear_junk' => 'admin/comments#clear_junk', :as => :clear_junk

  namespace :admin do
    resource :profile, :controller => 'users'
    resource :user_session, :only => :create
    resources :posts do
      post :publish
      post :quietly_publish
      post :revert
      post :takedown
    end
    resources :comments do
      post :junk
      post :notjunk
      collection do
        post :bulk_action
      end
    end
    resources :assets
    resources :tags
    resources :dashboard, :only => :index
  end

  get '/register' => 'admin/users#new'
  get '/login' => 'admin/user_sessions#new'
  get '/logout' => 'admin/user_sessions#destroy'

  get '/admin' => redirect('/admin/dashboard')

  get '/posts.:format' => 'home#posts', :format => 'atom'
  get '/comments.:format', :controller => 'home', :action => 'comments', :format => 'atom'

  get '/:tag/posts.:format', :controller => 'home', :action => 'posts', :format => 'atom'
  get '/:post/comments.:format', :controller => 'home', :action => 'comments', :format => 'atom'

  get '/tag/:label' => 'home#tag'
  get '/tag/:label.:format' => 'home#tag'

  get '/:permalink' => 'home#post'
  get '/:permalink/preview' => 'home#preview'
  get '/:permalink.:format' => 'home#post'

  post '/:permalink' => 'home#post'

  get ':controller(/:id(/:action(/:id)))'
  get ':controller(/:id(/:action(/:id(.:format))))'

  root :to => "home#index"
end
