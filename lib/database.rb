require 'sequel'
require 'logger'
require 'yaml'
# require 'user'
class Likes < Sequel::Model
end

class Database

  def initialize
    connect
    # create_table
  end

  def add user_id, like_id, category, name
    dataset.insert(user_id: user_id, like_id: like_id, category: category, name: name)
  end

  def get user_id
    # likes = dataset.
    #   select(:like_id, :category, :name).
    #   # filter(user_id: user_id).all
    #   where(user_id: user_id)

    # likes = Likes.where(user_id: user_id).collect do |u|
    #   {like_id: u.like_id, name: u.name, category: u.category}
    # end
    # User.new(user_id, likes)
    Likes.where(user_id: user_id).all
  end

  def get_all_user_ids
    # result = dataset.select_group(:user_id).all
    # result.map { |u| u[:user_id] }
    Likes.select(:user_id).group_by(:user_id).all
  end

  def get_all_users
    get_all_user_ids.collect {|u| get u}.flatten
  end

  def delete_all_for user_id
    dataset.filter(user_id: user_id).delete
  end

  private

  def connect
    if ENV['DATABASE_URL']
      env = URI.parse ENV['DATABASE_URL']
      config = {
        :adapter => env.scheme == 'postgres' ? 'postgresql' : env.scheme,
        :host => env.host,
        :username => env.user,
        :password => env.password,
        :database => env.path[1..-1],
        :encoding => 'utf8'
      }
      logger = nil
      config[:max_connections] = 1
    else
      config = YAML.load_file('./config/database.yml')[:development]
      logger = Logger.new(config[:log])
    end

    @db = Sequel.connect(config,
      :logger => logger,
      :max_connections => config[:max_connections]
    )
  end

  def create_table
    @db.drop_table :likes
    @db.create_table :likes do
      primary_key :id
      String :user_id
      String :like_id
      String :category
      String :name
    end
  end

  def dataset
    @dataset ||= @db[:likes]
  end
end
