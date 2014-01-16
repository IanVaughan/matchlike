require './lib/facebook'
require './lib/database'
require './lib/matcher'

class MatchLike
  attr_accessor :facebook, :database, :matcher

  def initialize
    @facebook = Facebook.new
    @database = Database.new
    @matcher = Matcher.new
  end

  def auth_user(user_id, user_name, token)
    facebook.user_id = user_id
    facebook.user_name = user_name
    facebook.auth(token) unless token.nil?
  end

  def save_likes
    facebook.likes.each do |like|
      database.add facebook.user_id, like['id'], like['category'], like['name']
    end
  end

  def get_likes
    database.get(facebook.user_id)
  end

  def get_matches
    matcher.show database.get_all_users
  end
end
