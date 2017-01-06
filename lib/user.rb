# class Like < Struct.new(:id, :name, :category)
# end

# class User < Struct.new(:user_id, :likes)
class Likes < Sequel::Model

  # def initialize(user_id, likes)
  #   @user_id = user_id
  #   @likes = []

  #   likes.each { |like| @likes << Like.new(like) }
  # end

  # def self.from_hash(hash)
  #   new *hash.values_at('user_id', 'likes')
  # end
end

__END__
[{:user_id=>"1",
  :like_id=>"2",
  :category=>"3",
  :name=>"4"},
 {:user_id=>"28",
  :like_id=>"2",
  :category=>"28_2_fake_category",
  :name=>"28_2_fake_name"},
 {:user_id=>"28",
  :like_id=>"76",
  :category=>"28_76_fake_category",
  :name=>"28_76_fake_name"},
 {:user_id=>"28",
  :like_id=>"99",
  :category=>"28_99_fake_category",
  :name=>"28_99_fake_name"},
 {:user_id=>"28",
  :like_id=>"8",
  :category=>"28_8_fake_category",
  :name=>"28_8_fake_name"},
 {:user_id=>"28",
  :like_id=>"60",
  :category=>"28_60_fake_category",
  :name=>"28_60_fake_name"},
 {:user_id=>"28",
  :like_id=>"95",
  :category=>"28_95_fake_category",
  :name=>"28_95_fake_name"},
 {:user_id=>"28",
  :like_id=>"86",
  :category=>"28_86_fake_category",
  :name=>"28_86_fake_name"},
 {:user_id=>"28",
  :like_id=>"83",
  :category=>"28_83_fake_category",
  :name=>"28_83_fake_name"},
 {:user_id=>"28",
  :like_id=>"55",
  :category=>"28_55_fake_category",
  :name=>"28_55_fake_name"},
 {:user_id=>"28",
  :like_id=>"46",
  :category=>"28_46_fake_category",
  :name=>"28_46_fake_name"},
 {:user_id=>"39",
  :like_id=>"8",
  :category=>"39_8_fake_category",
  :name=>"39_8_fake_name"},
