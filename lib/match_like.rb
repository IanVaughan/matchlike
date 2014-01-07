class MatchLike

  def initialize
    fb = FacebookConnection.new
    likes = fb.likes

    db = Database.new

    likes.each { |like| db.add(user, like) }
  end

end
