class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }

    configure do
        enable :sessions
        set :session_secret, "secret"
    end

    # Kind of like an index page but now showing all users. 
    get '/' do
        erb :home
    end

    # Kind of like a #new. Renders signup form.
    get '/registrations/signup' do
        erb :'/registrations/signup'
    end

    # Kind of line a #create. Post to new User.
    post '/registrations' do
        @user = User.new(name: params["name"], email: params["email"], password: params["password"])
        @user.save
        session[:user_id] = @user.id

        redirect '/users/home'
    end

    # Brings you to the login form.
    get '/sessions/login' do

        # the line of code below render the view page in app/views/sessions/login.erb
        erb :'sessions/login'
    end

    # Login in user via the form by finding the user in database.
    post '/sessions' do
        @user = User.find_by(email: params[:email], password: params[:password])
        if @user
        session[:user_id] = @user.id
        redirect '/users/home'
        end
        redirect '/sessions/login'
    end

    # Logs user out by clearing the session.
    get '/sessions/logout' do
        session.clear
        redirect '/'
    end


    # Kind of like a #show page.
    get '/users/home' do
        @user = User.find(session[:user_id])
        erb :'/users/home'
    end
end
