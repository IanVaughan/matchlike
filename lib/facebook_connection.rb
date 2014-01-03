class FacebookConnection
  attr_accessor :app_id, :app_secret, :scopes

  def initialize
    config ||= YAML.load_file('./config/config.yml')
    @app_id = config[:id]
    @app_secret = config[:secret]
    @scopes = config[:scopes].join(',')
    @callback_url = nil
  end

  def auth(oauth_access_token)
    @graph = Koala::Facebook::API.new(oauth_access_token)
  end

  def get_likes
    @graph.get_connections('me', 'likes', limit:1000)
  end
end
