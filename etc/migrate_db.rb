require 'data_mapper'
require 'dm-migrations'

dir = "/Users/edd/Desktop"
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{dir}/scores.db")

class Score
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String
  property :score,        Integer
  property :created_at,   DateTime
end

DataMapper.finalize
DataMapper.auto_migrate!