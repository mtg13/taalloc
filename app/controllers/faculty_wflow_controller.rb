class FacultyWflowController < ApplicationController
    def show
        currSemNum = session[:currSemNum]
        currSemYear = session[:currSemYear]
        nextSemNum = session[:nextSemNum]
        nextSemYear = session[:nextSemYear]
        current_faculty = session[:current_user]
        # List of all course names offered by the current faculty member for the current semester
        @courses = ActiveRecord::Base.connection.execute("select coursenum from instructor where instructor = \'#{current_faculty}\' and instructor.yearoffered = \'#{currSemYear}\' and instructor.semoffered = #{currSemNum}").map { |course| course["coursenum"] }

        @courseTAs = {}
        
        # For each course name ...
        @courses.each do |coursenum|
            # ... fetch the details of the TA for those courses
            @tadetails = ActiveRecord::Base.connection.execute("select ta, name, grade, comments from taalloc, students where coursenum=\'#{coursenum}\' and yearoffered=\'#{currSemYear}\' and semoffered=#{currSemNum} and taalloc.ta = students.id")
            # List of TA details for that course
            @courseTAs[coursenum] = @tadetails.map { |ta| ta }
        end
    end
    
    def submit
        currSemNum = session[:currSemNum]
        currSemYear = session[:currSemYear]
        nextSemNum = session[:nextSemNum]
        nextSemYear = session[:nextSemYear]
        current_faculty = session[:current_user]
        
        params[:course].each_pair do |coursenum, ta|
            #TODO there's a bug with inserting comments. Seems like there's always a tab and a newline when it's inserted
            ta.each_pair do |ta_id, ta_evaluation|
                puts "insert into taalloc values (\'#{ta_id}\',\'#{coursenum}\',\'#{currSemYear}\',#{currSemNum},#{ta_evaluation["tagrade"]}, $$\'#{ta_evaluation["tacomments"]}\'$$) on conflict (ta,coursenum,yearoffered,sem) do update set grade=excluded.grade, comments=excluded.comments"
                ActiveRecord::Base.connection.execute("insert into taalloc values (\'#{ta_id}\',\'#{coursenum}\',\'#{currSemYear}\',#{currSemNum},#{ta_evaluation["tagrade"]}, $$#{ta_evaluation["tacomments"].strip}$$) on conflict (ta,coursenum,yearoffered,semoffered) do update set grade=excluded.grade, comments=excluded.comments")
            end
        end
        
    end
end