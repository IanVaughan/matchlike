class FacebookConnection
  attr_accessor :app_id, :app_secret, :scopes

  def initialize
    config ||= YAML.load_file('./config/facebook.yml')
    @app_id = config[:id]
    @app_secret = config[:secret]
    @scopes = config[:scopes].join(',')
    @callback_url = config[:callback_url]
  end

  def auth(oauth_access_token)
    @graph = Koala::Facebook::API.new(oauth_access_token)
  end

  def likes
    @graph.get_connections('me', 'likes', limit:1000)
  end

  def like_link(id)
    link = @graph.get_object(id)
    if link && link['cover'] && link['cover']['source']
      link['cover']['source']
    else
      ''
    end
  end

end
