Rails3dojo::Application.routes.draw do
  # You can have the root of your site routed with "root"
  root :to => "welcome#index"
    
  resources :pages
  resources :sessions
  
  match ':title' => 'pages#show', :via => [:get], :as => :wiki_page
end
