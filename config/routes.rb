Rails.application.routes.draw do
  get '/student_wflow', to: 'student_wflow#show'
  get '/student_wflow/not_found', to: 'student_wflow#not_found'
  post '/student_wflow', to: 'student_wflow#submit'
  
  get '/faculty_wflow_feedback', to: 'faculty_wflow#show_feedback_form'
  post '/faculty_wflow_feedback', to: 'faculty_wflow#submit_feedback_form'
  
  get '/faculty_wflow_course_setup', to: 'faculty_wflow#show_course_setup'
  post '/faculty_wflow_course_setup', to: 'faculty_wflow#submit_course_setup'
  
  get '/faculty_wflow_ta_setup_ta_count', to: 'faculty_wflow#show_ta_setup_ta_count'
  post '/faculty_wflow_ta_setup_ta_count', to: 'faculty_wflow#submit_ta_setup_ta_count'
  get '/faculty_wflow_ta_setup_preferences', to: 'faculty_wflow#show_ta_setup_preferences'
  post '/faculty_wflow_ta_setup_preferences', to: 'faculty_wflow#submit_ta_setup_preferences'
  
  get '/student/:id', to: 'students#show'
  
  get '/', to: 'main#index'
  get '/login', to: 'main#login'
  get '/logout', to: 'main#logout'
end
