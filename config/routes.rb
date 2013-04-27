Rails.application.routes.draw do
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
  
  match '/register' => 'admin/users#new'
  match '/login' => 'admin/user_sessions#new'
  match '/logout' => 'admin/user_sessions#destroy'
  
  match '/admin' => redirect('/admin/dashboard')
  
  match '/posts.:format' => 'home#posts', :format => 'atom'
  match '/comments.:format', :controller => 'home', :action => 'comments', :format => 'atom'
  
  match '/:tag/posts.:format', :controller => 'home', :action => 'posts', :format => 'atom'
  match '/:post/comments.:format', :controller => 'home', :action => 'comments', :format => 'atom'
  
  match '/tag/:label' => 'home#tag'
  match '/tag/:label.:format' => 'home#tag'
  
  match '/:permalink' => 'home#post'
  match '/:permalink/preview' => 'home#preview'
  match '/:permalink.:format' => 'home#post'
  
  match ':controller(/:id(/:action(/:id)))'
  match ':controller(/:id(/:action(/:id(.:format))))'
  
  root :to => "home#index"
end