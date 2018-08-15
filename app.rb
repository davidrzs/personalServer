# gem install mongo
# gem install bson_ext

require 'sinatra/base'
require 'digest'
require 'mongo'
require 'json/ext' # required for .to_json


class App < Sinatra::Base
  configure do
    db = Mongo::Client.new('mongodb://127.0.0.1:27017/db')
    set :temperature_db, db[:temperature_db]
  end
  
  get "/" do
    "hello world"
  end

  get "/debug" do
    settings.temperature_db.find.first.to_json
  end

  get "/temp" do
    apiKey = params['apiKey']
    temperature = params['temperature']
    station = params['station']
    doc = { time: Time.now, temperature: temperature, station: station }
    settings.temperature_db.insert_one(doc)
=begin
     if '80a13a67f485849a3ba8d80dbe87e029886cb90fd6c74a34de00aceb1afe795b26f5cd0743f5c19f1caf239037bd5b3e4047c8201ce5b9167c5111901acc9321' == Digest::SHA512.hexdigest(params['apiKey']).to_s

     else
       403
     end
=end
  end

  error 403 do
    'Access forbidden'
  end
  helpers do
    # a helper method to turn a string ID
    # representation into a BSON::ObjectId
    def object_id val
      begin
        BSON::ObjectId.from_string(val)
      rescue BSON::ObjectId::Invalid
        nil
      end
    end

    def document_by_id id
      id = object_id(id) if String === id
      if id.nil?
        {}.to_json
      else
        document = settings.mongo_db.find(:_id => id).to_a.first
        (document || {}).to_json
      end
    end
  end

end
