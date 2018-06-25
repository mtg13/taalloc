require 'net/http'

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
                redirect_to '/faculty_wflow_menu' and return
            end
        else
            # redirect to login and set session[:current_user] and session[:current_user_type]
            redirect_to '/login' and return
        end
    end

    # TODO!!
    def login
      # Initial call with our client_id
      # This call results in a redirect to the URL we have specified
#https://oauth.iitd.ac.in/authorize.php?response_type=code&client_id=jYUWkem7KgLLYjzEqWdPdN2Q9Kb1dktw&state=xyz
        @uri = URI("https://oauth.iitd.ac.in/authorize.php")
        @params = { :response_type => 'code', :client_id => 'jYUWkem7KgLLYjzEqWdPdN2Q9Kb1dktw', :state => 'xyz' }
        @uri.query = URI.encode_www_form(@params)
        @res = Net::HTTP.get_response(uri) ## Not sure how this will work
        puts @res.body @res.is_a?(Net::HTTPSuccess)

    # The code below here, is in a function that is executed from the redirect URL
    # Get 'code' sent by the oauth server and send it to https://oauth.iitd.ac.in/token.php with params client_id: cid, client_secret: csecret, grant_type: 'authorization_code', code: <extracted from res above>
    # This will return the access_token
      @uri = URI("https://oauth.iitd.ac.in/token.php")
      @params = { :client_id => 'jYUWkem7KgLLYjzEqWdPdN2Q9Kb1dktw_this_will_change', :client_secret => 'will_get_this_later', :grant_type => 'authorization_code', code: 'has_to_be_extracted' }
      @uri.query = URI.encode_www_form(@params)
      @res = Net::HTTP.get_response(uri) ## Not sure how this will work
      puts @res.body res.is_a?(Net::HTTPSuccess)

    # Response from above, will give us 'access_token'. Send this to 'https://oauth.iitd.ac.in/resource.php' with params access_token: access_token
    # This will return the user details: (user_id, mail, name, uniqueiitdid, category, department)
      @uri = URI("https://oauth.iitd.ac.in/resource.php")
      @params = { :access_token => 'has_to_be_extracted' }
      @uri.query = URI.encode_www_form(@params)
      @res = Net::HTTP.get_response(uri) ## Not sure how this will work
      puts @res.body res.is_a?(Net::HTTPSuccess)


   # Response from the above will give us the user details (user_id, mail, name, uniqueiitdid, category, department)

        session[:current_user] = "naveen" # "mcs172105" #
        session[:current_user_type] = "faculty"
        redirect_to '/'
    end
    
    def access_denied
    end

    def logout
        session[:current_user] = nil
        session[:current_user_type] = nil
        redirect_to '/'
    end
end
