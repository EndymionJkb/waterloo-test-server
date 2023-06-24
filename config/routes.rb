Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'

  resources :assessments

  get '/available_tests', to: 'assessments#available_tests'
  get '/get_test', to: 'assessments#get_test'
end
