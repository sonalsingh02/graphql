Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  post '/movies', to: 'movies#query'
  post "/actors", to: 'actors#query'
  get '/actors', to: 'actors#query'
  post '/users', to: 'users#query'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/movies', to: 'movies#query'

  #get '/patients/:id', to: 'patients#show'
end
