class StudentsController < ApplicationController
    before_action :check_login
    
    def show
        @student = params[:id]
        
        @student_information = ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql(["select studentgrades.coursenum, coursename, grade from studentgrades, coursenames where id = ? and studentgrades.coursenum = coursenames.coursenum", @student])).map { |info| info }
    end
    
    def check_login
        if(session[:current_user] == nil)
            redirect_to '/' and return
        elsif(session[:current_user_type] != 'faculty')
            redirect_to '/access_denied' and return
        end
    end
end
