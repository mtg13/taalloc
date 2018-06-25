class StudentsController < ApplicationController
    def show
        @student = params[:id]
        
        @student_information = ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql(["select studentgrades.coursenum, coursename, grade from studentgrades, coursenames where id = ? and studentgrades.coursenum = coursenames.coursenum", @student])).map { |info| info }
    end
end
