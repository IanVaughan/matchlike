class FacebookConnection

  def initialize(oauth_access_token)
    # app_id, app_secret, callback_url = 1435770329973305, '027a9b991a6d50d846ac14256e738b65', nil

    # oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)

    # oauth_access_token = oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(oauth_access_token)
  end

  def get_likes
    @graph.get_connections("me", "likes", limit:1000)
  end
end
