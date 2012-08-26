require 'sinatra'
require 'data_mapper'
require 'dm-migrations'

dir = "/Users/edd/Desktop"
DataMapper.setup(:default, "sqlite://#{dir}/scores.db")

class Score
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String
  property :score,        Integer
  property :created_at,   DateTime
end

DataMapper.finalize

get '/scores' do
  @scores = Score.all(:order => [ :score.desc ])
  erb :index
end

post '/add_score' do
  @score = Score.create(:name => params['name'], :score => params['score'].to_i, :created_at => Time.now)
end