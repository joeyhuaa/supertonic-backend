Rails.application.routes.draw do
  resources :audios
  resources :users, only: [:create, :show, :index]

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logged_in', to: 'sessions#is_logged_in?'
  post '/signup', to: 'users#create'

  get 'api/user/theme', to: 'users#theme'
  put 'api/user/change_theme', to: 'users#change_theme'

  get 'api/songs/:id', to: 'song#get'
  # delete 'api/songs/:id/destroy', to: 'song#destroy'
  post 'api/songs/:id/update', to: 'song#update'

  get 'api/projects', to: 'project#get_all'
  post 'api/projects/new', to: 'project#new'
  post 'api/projects/:id', to: 'project#get'
  put 'api/projects/:id/add_songs', to: 'project#add_songs'
  # put 'api/audios/new', to: 'audios#new'
  put 'api/projects/:id/change_name', to: 'project#change_name'
  delete 'api/projects/:id/destroy', to: 'project#destroy'
  put 'api/projects/:id/new_branch', to: 'project#new_branch'
  put 'api/projects/:id/delete_branch', to: 'project#delete_branch'
  put 'api/projects/:id/delete_song', to: 'project#delete_song'
  put 'api/projects/:id/replace_song', to: 'project#replace_song'
  put 'api/projects/:id/invite_user', to: 'project#invite_user'

  get 'api/shared/projects/:id', to: 'pages#shared_project'
end