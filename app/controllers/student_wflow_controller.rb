class StudentWflowController < ApplicationController
    before_action :check_login, :setup_context
    
    def show
        # Check student eligibility
        eligible_id_list = ActiveRecord::Base.connection.execute("select id from phdtas union select id from msrtas union select id from mtechtas union select id from dualtas").map { |id| id["id"].strip }.to_a
        if(!eligible_id_list.include?(@current_student))
            redirect_to action: "not_found" and return
        end
        # Get current preferences
        @courses = ActiveRecord::Base.connection.execute("select distinct sprefs.coursenum, courses.coursename, courses.core, instructor.instructor, instructor.description, sprefs.priority from sprefs, courses, instructor where sprefs.id=\'#{@current_student}\' and instructor.yearoffered=\'#{@nextSemYear}\' and instructor.semoffered=#{@nextSemNum} and sprefs.coursenum = courses.coursenum and instructor.coursenum=sprefs.coursenum and courses.yearoffered=\'#{@nextSemYear}\' and courses.sem=#{@nextSemNum} order by sprefs.coursenum").map { |course| [course["coursenum"], course] }.to_h
    end
    
    def not_found
    end
    
    def submit
        # TODO: Sanitize!
        params[:course_priority].each_pair do |coursenum, priority|
            ActiveRecord::Base.connection.execute("insert into sprefs values (\'#{@current_student}\',\'#{coursenum}\',\'#{@nextSemYear}\',#{@nextSemNum},#{priority}) on conflict (id,coursenum,yearoffered,semoffered) do update set priority=excluded.priority")
        end
    end
    
    def setup_context
        @currSemNum = session[:currSemNum]
        @currSemYear = session[:currSemYear]
        @nextSemNum = session[:nextSemNum]
        @nextSemYear = session[:nextSemYear]
        @current_student = session[:current_user]
    end
    
    def check_login
        if(session[:current_user] == nil)
            redirect_to '/' and return
        elsif(session[:current_user_type] != 'student')
            redirect_to '/access_denied' and return
        end
    end
end
