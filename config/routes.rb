Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'

  resources :assessments
  resources :users, :only => [:index, :destroy]
  resources :test_logs, :only => [:index, :destroy]

  get '/available_tests', to: 'assessments#available_tests'
  get '/get_questions', to: 'assessments#get_questions'
  get '/score_test', to: 'assessments#score_test'
end
