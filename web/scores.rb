require 'sinatra'
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

get '/scores' do
  @scores = Score.all(:order => [ :score.desc ], :limit => 10)
  @scores.map { |score| "#{score.id},#{score.name},#{score.score}" }.join("\n")
end

post '/scores' do
  @score = Score.create(:name => params['name'], :score => params['score'].to_i, :created_at => Time.now)
end