require 'koala'
require 'sinatra'
require 'sinatra/cookies'
require 'omniauth-facebook'
require './helpers/get_post'
require 'pry'
require './lib/facebook_connection'

class Server < Sinatra::Base
  helpers Sinatra::Cookies

  use Rack::Session::Pool
  set :protection, :except => :frame_options

  set :views, File.dirname(__FILE__) + "/../views"
  set :public_folder, File.dirname(__FILE__) + "/../public"

  OmniAuth.config.on_failure = lambda do |env|
    [302, {'Location' => '/auth/failure', 'Content-Type' => 'text/html'}, []]
  end

  configure do
    set :redirect_uri, nil
  end

  use OmniAuth::Builder do
    APP_ID = 1435770329973305
    APP_SECRET = '027a9b991a6d50d846ac14256e738b65'

    provider :facebook, APP_ID, APP_SECRET, { :scope => 'user_likes, user_photos' }
  end

  get '/' do
    @articles = []
    @articles << {:title => 'Getting Started with Heroku', :url => 'https://devcenter.heroku.com/articles/quickstart'}
    @articles << {:title => 'Deploying Rack-based apps in Heroku', :url => 'http://docs.heroku.com/rack'}
    @articles << {:title => 'Learn Ruby in twenty minutes', :url => 'http://www.ruby-lang.org/en/documentation/quickstart/'}

    erb :index
  end
  post '/' do
    @articles = []
    @articles << {:title => 'Getting Started with Heroku', :url => 'https://devcenter.heroku.com/articles/quickstart'}
    @articles << {:title => 'Deploying Rack-based apps in Heroku', :url => 'http://docs.heroku.com/rack'}
    @articles << {:title => 'Learn Ruby in twenty minutes', :url => 'http://www.ruby-lang.org/en/documentation/quickstart/'}

    erb :index
  end

  get '/auth/facebook/callback' do
    fb_auth = request.env['omniauth.auth']
    session['fb_auth'] = fb_auth
    session['fb_token'] = fb_auth['credentials']['token']
    session['fb_error'] = nil
    session['fb'] = FacebookConnection.new(session['fb_token'])
    redirect '/'
  end

  get '/auth/failure' do
    clear_session
    session['fb_error'] = 'Please allow access to your Facebook data...<br />'
    redirect '/'
  end

  get '/login' do
    if settings.redirect_uri
      # we're in FB
      erb :dialog_oauth
    else
      # we aren't in FB (standalone app)
      redirect '/auth/facebook'
    end
  end

  get '/logout' do
    clear_session
    redirect '/'
  end

  # access point from FB, Canvas URL and Secure Canvas URL must be point to this route
  # Canvas URL: http://your_app/canvas/
  # Secure Canvas URL: https://your_app:443/canvas/
  post '/canvas/' do

    # User didn't grant us permission in the oauth dialog
    redirect '/auth/failure' if request.params['error'] == 'access_denied'

    # see /login
    settings.redirect_uri = 'https://apps.facebook.com/faceboku/'

    # Canvas apps send the 'code' parameter
    # We use it to know if we're accessing the app from FB's iFrame
    # If so, we try to autologin
    url = request.params['code'] ? "/auth/facebook?signed_request=#{request.params['signed_request']}&state=canvas" : '/login'
    redirect url
  end

  def clear_session
    session['fb_auth'] = nil
    session['fb_token'] = nil
    session['fb_error'] = nil
  end

end
