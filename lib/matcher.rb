class Matcher

  def initialize
  end

  def match(user_a, user_b)
    to_match = user_b.map { |k| k[:like_id] }
    matching = user_a.keep_if {|v| to_match.include? v[:like_id] }
    matching.map { |k| k[:like_id] }
  end

  def sort(users)
    users.sort { |user_a, user_b| match(user_a, user_b).count }
    users.delete_if {|x| x == []}
    users.reverse
  end

  def show(users)
    result = {}
    sort(users).each do |user|
      result[user.first[:user_id]] ||= []
      user.each do |u|
        result[u[:user_id]] << u[:like_id]
      end
    end
    result
  end
end
