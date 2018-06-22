class MainController < ApplicationController
    def index
        session[:currSemNum] = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemNum\'").values[0][0]
        session[:currSemYear] = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemYear\'").values[0][0]
        session[:nextSemNum] = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemNum\'").values[0][0]
        session[:nextSemYear] = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemYear\'").values[0][0]
        if(session[:current_user])
            if(session[:current_user_type] == "student")
                redirect_to '/student_wflow' and return
            else
                redirect_to '/faculty_wflow' and return
            end
        else
            # redirect to login and set session[:current_user] and session[:current_user_type]
            redirect_to '/login' and return
        end
    end
    
    # TODO!!
    def login
        session[:current_user] = "naveen" # "mcs172105" # 
        session[:current_user_type] = "faculty" 
        redirect_to '/'
    end
    
    def logout
        session[:current_user] = nil
        session[:current_user_type] = nil
        redirect_to '/'
    end
end
