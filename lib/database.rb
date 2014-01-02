require 'sequel'

class Database

  def initialize
    connect
    create_table
  end

  def connect
    @db = Sequel.connect(
      "postgres://user:password@host:port/database_name",
      :max_connections => 10,
      :logger => Logger.new('log/db.log'))
  end

  def create_table
    @db.create_table :likes do
      primary_key :id
      Integer :user_id
      Integer :id
    end
  end

  def dataset
    @dataset ||= @db[:items]
  end

  def add user, item
    dataset.insert(user_id: user.id, id: item.id)
  end
end
