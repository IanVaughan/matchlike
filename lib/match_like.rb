require './lib/facebook'
require './lib/database'
require './lib/matcher'
require 'pry'

class MatchLike
  attr_accessor :facebook, :database, :matcher

  def initialize
    @facebook = Facebook.new
    @database = Database.new
  end

  def auth_user(user_id, user_name, token)
    facebook.user_id = user_id
    facebook.user_name = user_name
    facebook.auth(token) unless token.nil?
  end

  def save_likes
    facebook.likes.each do |like|
      database.add(facebook.user_id, like['id'], like['category'], like['name'])
    end
  end

  def get_likes
    # convert into User
    # database.get(facebook.user_id)
  end

  def get_matches
    # convert into User
    u = database.get_all_users
    # @matcher = Matcher.new()
    # matcher.show
  end
end
