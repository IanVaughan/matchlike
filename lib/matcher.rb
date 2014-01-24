require './lib/user'

class Matcher

  def initialize(base_user)
    @base_user = base_user
  end

  def match(to_this_user)
    base_user.likes.dup.keep_if { |v| to_this_user.likes.include? v }
  end

  def sort(users)
    users.keep_if { |u| match(u).any? }
    users.sort_by! { |u| match(u).count }
    users.reverse
  end

  def show(users)
    result = Hash.new { |hash, key| hash[key] = [] }
    sort(users).each do |user|
      user.each do |u|
        result[u[:user_id]] << u[:like_id]
      end
    end
    result
  end

  private
  attr_reader :base_user
end
