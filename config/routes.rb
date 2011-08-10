Rails3dojo::Application.routes.draw do
  root :to => "welcome#index"
    
  resources :sessions

  resources :pages do
    resources :comments
  end
  
  match ':title' => 'pages#show', :via => [:get], :as => :wiki_page
end
