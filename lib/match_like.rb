require './lib/facebook'
require './lib/database'

class MatchLike
  attr_accessor :facebook, :database

  def initialize
    @facebook = Facebook.new
    @database = Database.new
  end

  def auth_user(id, token)
    facebook.id = id
    facebook.auth(token)
  end

  def save_likes
    facebook.likes.each do |like|
      database.add facebook.user_id, like['id'], like['category'], like['name']
    end
  end

  def get_likes
    database.get(facebook.user_id)
  end
end
