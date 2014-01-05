require 'sequel'

class Database

  def initialize
    connect
    # create_table
  end

  def connect
    config = YAML.load_file('./config/database.yml')[:development]
    @db = Sequel.connect(config,
      :logger => Logger.new(config[:log]),
      :max_connections => config[:max_connections]
    )
  end

  def create_table
    @db.drop_table :likes
    @db.create_table :likes do
      primary_key :id
      String :user_id
      String :id
      String :category
      String :name
    end
  end

  def dataset
    @dataset ||= @db[:likes]
  end

  def add user_id, item_id, category, name
    dataset.insert(user_id: user_id, id: item_id, category: category, name: name)
  end

  def get_all_for user_id
    dataset.filter(user_id: user_id)
  end
end
