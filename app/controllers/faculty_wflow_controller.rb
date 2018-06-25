class FacultyWflowController < ApplicationController
    before_action :setup_context
    
    def show_feedback_form
        # List of all course names offered by the current faculty member for the current semester
        @courses = ActiveRecord::Base.connection.execute("select coursenum from instructor where instructor = \'#{@current_faculty}\' and instructor.yearoffered = \'#{@currSemYear}\' and instructor.semoffered = #{@currSemNum}").map { |course| course["coursenum"] }

        @courseTAs = {}
        
        # For each course name ...
        @courses.each do |coursenum|
            # ... fetch the details of the TA for those courses
            @tadetails = ActiveRecord::Base.connection.execute("select ta, name, grade, comments from taalloc, students where coursenum=\'#{coursenum}\' and yearoffered=\'#{@currSemYear}\' and semoffered=#{@currSemNum} and taalloc.ta = students.id")
            # List of TA details for that course
            @courseTAs[coursenum] = @tadetails.map { |ta| ta }
        end
    end
    
    def submit_feedback_form
        # TODO: Sanitize!
        params[:course].each_pair do |coursenum, ta|
            ta.each_pair do |ta_id, ta_evaluation|
                ActiveRecord::Base.connection.execute("insert into taalloc values (\'#{ta_id}\',\'#{coursenum}\',\'#{@currSemYear}\',#{@currSemNum},#{ta_evaluation["tagrade"]}, $$#{ta_evaluation["tacomments"].strip}$$) on conflict (ta,coursenum,yearoffered,semoffered) do update set grade=excluded.grade, comments=excluded.comments")
            end
        end
    end
    
    def show_course_setup
        @courses = ActiveRecord::Base.connection.execute("select coursenum, description from instructor where instructor = \'#{@current_faculty}\' and instructor.yearoffered = \'#{@nextSemYear}\' and instructor.semoffered = \'#{@nextSemNum}\'").map { |coursenum| coursenum }
    end
    
    def submit_course_setup
        # TODO: Sanitize!
        params[:course].each_pair do |coursenum, details|
            ActiveRecord::Base.connection.execute("insert into instructor values (\'#{coursenum}\',\'#{@nextSemYear}\',#{@nextSemNum},\'#{@current_faculty}\',$$#{details["description"]}$$) on conflict (coursenum,yearoffered,semoffered,instructor) do update set description=excluded.description")
        end
    end
    
    def show_ta_setup_ta_count
        @courses = ActiveRecord::Base.connection.execute("select coursenum from instructor where instructor = \'#{@current_faculty}\' and instructor.yearoffered = \'#{@nextSemYear}\' and instructor.semoffered = \'#{@nextSemNum}\'").map { |coursenum| coursenum }
        
        @tacount = {}
        @courses.each do |details|
             record = ActiveRecord::Base.connection.execute("select phd, msr, dual, mtech from tacount where coursenum=\'#{details["coursenum"]}\' and yearoffered=\'#{@nextSemYear}\' and semoffered=#{@nextSemNum}")[0]
             @tacount[details["coursenum"]] = {}
             record.each_pair do |tatype, count|
                @tacount[details["coursenum"]][tatype] = count
             end
        end
        
        puts @tacount.to_s
    end
    
    def submit_ta_setup_ta_count
        # TODO: Sanitize!
        params[:tacount].each_pair do |coursenum, tacounts|
            ActiveRecord::Base.connection.execute("insert into tacount values (\'#{coursenum}\',\'#{@nextSemYear}\',#{@nextSemNum},#{tacounts["phd"]},#{tacounts["msr"]},#{tacounts["dual"]},#{tacounts["mtech"]}) on conflict (coursenum,yearoffered,semoffered) do update set phd=excluded.phd, msr=excluded.msr, mtech=excluded.mtech, dual=excluded.dual")
        end
        redirect_to '/faculty_wflow_ta_setup_preferences' and return
    end
    
    def show_ta_setup_preferences
        @courses = ActiveRecord::Base.connection.execute("select coursenum from instructor where instructor = \'#{@current_faculty}\' and instructor.yearoffered = \'#{@nextSemYear}\' and instructor.semoffered = \'#{@nextSemNum}\'").map { |coursenum| coursenum }
        
        @tas = {}
        
        @courses.each do |details|
            coursenum = details["coursenum"]
            @tas[coursenum] = {}
            @tas[coursenum]["phd"] = ActiveRecord::Base.connection.execute("select iprefs.id, phdtas.name, cgpa, priority from iprefs, phdtas, currentcgpa where iprefs.coursenum=\'#{coursenum}\' and yearoffered=\'#{@nextSemYear}\' and semoffered=#{@nextSemNum} and iprefs.id = phdtas.id and iprefs.id = currentcgpa.id order by cgpa").map{ |ta| ta }
            @tas[coursenum]["mtech"] = ActiveRecord::Base.connection.execute("select iprefs.id, mtechtas.name, cgpa, priority from iprefs, mtechtas, currentcgpa where iprefs.coursenum=\'#{coursenum}\' and yearoffered=\'#{@nextSemYear}\' and semoffered=#{@nextSemNum} and iprefs.id = mtechtas.id and iprefs.id = currentcgpa.id order by cgpa").map{ |ta| ta }
            @tas[coursenum]["msr"] = ActiveRecord::Base.connection.execute("select iprefs.id, msrtas.name, cgpa, priority from iprefs, msrtas, currentcgpa where iprefs.coursenum=\'#{coursenum}\' and yearoffered=\'#{@nextSemYear}\' and semoffered=#{@nextSemNum} and iprefs.id = msrtas.id and iprefs.id = currentcgpa.id order by cgpa").map{ |ta| ta }
            @tas[coursenum]["dual"] = ActiveRecord::Base.connection.execute("select iprefs.id, dualtas.name, cgpa, priority from iprefs, dualtas, currentcgpa where iprefs.coursenum=\'#{coursenum}\' and yearoffered=\'#{@nextSemYear}\' and semoffered=#{@nextSemNum} and iprefs.id = dualtas.id and iprefs.id = currentcgpa.id order by cgpa").map{ |ta| ta }
        end
        
        puts @tas.to_s
    end
    
    def submit_ta_setup_preferences
        params[:tapref].each_pair do |coursenum, prefs|
            prefs.each_pair do |taid, priority|
                ActiveRecord::Base.connection.execute("insert into iprefs values (\'#{coursenum}\',\'#{@nextSemYear}\',#{@nextSemNum},\'#{taid}\',#{priority}) on conflict (id,coursenum,yearoffered,semoffered) do update set priority=excluded.priority")
            end
        end
    end
    
    def setup_context
        @currSemNum = session[:currSemNum]
        @currSemYear = session[:currSemYear]
        @nextSemNum = session[:nextSemNum]
        @nextSemYear = session[:nextSemYear]
        @current_faculty = session[:current_user]
    end
end
