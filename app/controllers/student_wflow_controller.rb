class StudentWflowController < ApplicationController
	def show
		currSemNum = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemYear\'").values[0][0]
		currSemYear = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemYear\'").values[0][0]
		nextSemNum = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemNum\'").values[0][0]
		nextSemYear = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemYear\'").values[0][0]
		puts nextSemYear
		puts nextSemYear.class
		current_student = "mcs172105" # This should be generated on the main page and stored in the session
		# Check student eligibility
		eligible_id_list = ActiveRecord::Base.connection.execute("select id from phdtas union select id from msrtas union select id from mtechtas union select id from dualtas").map { |id| id["id"].strip }.to_a
		if(!eligible_id_list.include?(current_student))
			redirect_to action: "not_found" and return
		end
		# Get current preferences
		@courses = ActiveRecord::Base.connection.execute("select distinct sprefs.coursenum, courses.coursename, courses.core, instructor.instructor, instructor.description, sprefs.priority from sprefs, courses, instructor where sprefs.id=\'#{current_student}\' and instructor.yearoffered=\'#{nextSemYear}\' and instructor.semoffered=#{nextSemNum} and sprefs.coursenum = courses.coursenum and instructor.coursenum=sprefs.coursenum and courses.yearoffered=\'#{nextSemYear}\' and courses.sem=#{nextSemNum} order by sprefs.coursenum").map { |course| [course["coursenum"], course] }.to_h
		puts @courses
	end

	def not_found
	end

	def submit
		currSemNum = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemYear\'").values[0][0]
		currSemYear = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'currSemYear\'").values[0][0]
		nextSemNum = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemNum\'").values[0][0]
		nextSemYear = ActiveRecord::Base.connection.execute("select value from config where config.attr=\'nextSemYear\'").values[0][0]
		current_student = "mcs172105"
		params[:course_priority].each_pair do |coursenum, priority|
			ActiveRecord::Base.connection.execute("insert into sprefs values (\'#{current_student}\',\'#{coursenum}\',\'#{nextSemYear}\',#{nextSemNum},#{priority}) on conflict (id,coursenum,yearoffered,semoffered) do update set priority=excluded.priority")
		end
		puts params
	end
end
