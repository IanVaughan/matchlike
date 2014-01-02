class MatchLike

  def initialize
    fb = FacebookConnection.new
    likes = fb.get_likes

    db = Database.new

    likes.each do |like|
      db.add user, like
    end
  end

end
