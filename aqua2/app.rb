require 'sinatra'
require 'dm-core'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})
class Filter
  include DataMapper::Resource
  property :id, Serial                             
  property :reference, String 
  property :lat, Float
  property :lon, Float
  property :status, Integer #0: add filter, 1: update performance
  property :b_quality, Integer
  property :a_quality, Integer
  property :date, Date
end
DataMapper.finalize

# Main route  - this is the form is shown
get '/' do
  erb :home
end

get '/filter' do
  erb :filter
end

get '/member' do
  erb :member
end

get '/perform' do
  @f = Filter.all(:status => "0")
  erb :perform
end

get '/adminfilters' do
  @f = Filter.all
  erb :admin
end

get '/map' do
  @f = Filter.all
  erb :map
end

post '/save' do 
  # create a new datamapper object
  if (params[:password] == "0000")
    @f = Filter.new
    @f.reference = params[:reference]
    @f.lat = params[:lat]
    @f.lon = params[:lon]
    @f.date = params[:date]
    @f.status = 0;
    @f.save
    erb :save
  else
    erb :noaccess
  end
end

post '/edit/:id' do
  @f = Filter.get(params[:id])
  erb :edit
end

post '/delete/:id' do
  #if (params[:password] == "0000")
    f = Filter.get(params[:id])
    f.destroy
    erb :delete
  #else
  #  erb :noaccess
  #end
end

post '/save_new/:id' do
  @f = Filter.get(params[:id])
  if (params[:password] == "0000")
    @f.reference = params[:reference]
    @f.lat = params[:lat]
    @f.lon = params[:lon]
    @f.date = params[:date]
    @f.status = 0;
    # password?
    @f.save
    erb :save
  else
    erb :noaccess
  end
end

post '/saveperform' do
  if (params[:password] == "0000")
    @f = Filter.new
    @f.reference = params[:reference]
    @f.b_quality = params[:b_quality]
    @f.a_quality = params[:a_quality]
    @f.date = params[:date]
    @f.status = 1;
    @f.save
    erb :saveperform
  else
    erb :noaccess
  end
end