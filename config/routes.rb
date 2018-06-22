Rails.application.routes.draw do
  resources :students
  get '/student_wflow', to: 'student_wflow#show'
  get '/student_wflow/not_found', to: 'student_wflow#not_found'
  post '/student_wflow', to: 'student_wflow#submit'
  
  get '/faculty_wflow', to: 'faculty_wflow#show'
  post '/faculty_wflow', to: 'faculty_wflow#submit'
  
  get '/', to: 'main#index'
  get '/login', to: 'main#login'
  get '/logout', to: 'main#logout'
end
