require 'koala'
require 'sinatra'
require 'omniauth-facebook'
require 'pry'
require './lib/match_like'

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

    ML = MatchLike.new
  end

  use OmniAuth::Builder do
    provider :facebook, ML.facebook.app_id, ML.facebook.app_secret, { :scope => ML.facebook.scopes }
  end

  get '/' do
    if session[:logged_in]
      session[:flash] = ''
    else
      session[:flash] = 'Please connect to Facebook to use this app'
    end
    erb :index
  end

  get '/auth/facebook/callback' do
    fb_auth = request.env['omniauth.auth']
    session[:logged_in] = true
    session[:flash] = 'You have connected to Facebook'

    session[:user] = MatchLike.new
    session[:user].auth_user(fb_auth['uid'], fb_auth['credentials']['token'])

    session[:user].save_likes
    redirect '/'
  end

  # get '/processing' do
  #   erb :processing
  # end

  get '/likes' do
    erb :likes
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
