require 'koala'
require 'sinatra'
require 'omniauth-facebook'
require './helpers/get_post'
require 'pry'
require './lib/facebook'
require './lib/database'

class Server < Sinatra::Base

  use Rack::Session::Pool
  set :protection, :except => :frame_options

  set :views, File.dirname(__FILE__) + '/../views'
  set :public_folder, File.dirname(__FILE__) + '/../public'

  OmniAuth.config.on_failure = lambda do |env|
    [302, {'Location' => '/auth/failure', 'Content-Type' => 'text/html'}, []]
  end

  configure do
    set :redirect_uri, nil

    FACEBOOK = Facebook.new
    DATABASE = Database.new
  end

  use OmniAuth::Builder do
    provider :facebook, FACEBOOK.app_id, FACEBOOK.app_secret, { :scope => FACEBOOK.scopes }
  end

  get '/' do
    if !session[:logged_in]
      session[:flash] = 'Please connect to Facebook to use this app'
    else
      session[:flash] = ''
    end
    erb :index
  end

  get '/auth/facebook/callback' do
    fb_auth = request.env['omniauth.auth']
    session[:logged_in] = true
    session[:flash] = 'You have connected to Facebook'
    session[:name] = fb_auth['info']['first_name']

    FACEBOOK.auth(fb_auth['credentials']['token'])
    FACEBOOK.likes.each do |like|
      DATABASE.add fb_auth['uid'], like['id'], like['category'], like['name']
    end

    session[:likes] = DATABASE.get(fb_auth['uid'])
    session[:graph] = FACEBOOK
    redirect '/'
  end

  get '/auth/failure' do
    session[:logged_in] = false
    session[:flash] = 'Please allow access to your Facebook data...'
    redirect '/'
  end

  get '/login' do
    if settings.redirect_uri
      erb :dialog_oauth
    else
      redirect '/auth/facebook'
    end
  end

  get '/logout' do
    session[:logged_in] = false
    session[:flash] = 'You have disconnected from Facebook'
    redirect '/'
  end

  # access point from FB, Canvas URL and Secure Canvas URL must be point to this route
  # Canvas URL: http://your_app/canvas/
  # Secure Canvas URL: https://your_app:443/canvas/
  post '/canvas/' do
    redirect '/auth/failure' if request.params['error'] == 'access_denied'

    settings.redirect_uri = 'https://apps.facebook.com/matchlike/'

    url = if request.params['code']
      "/auth/facebook?signed_request=#{request.params['signed_request']}&state=canvas"
    else
      '/login'
    end
    redirect url
  end

end
