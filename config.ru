require File.expand_path('app', File.dirname(__FILE__))

configure do
  db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'db')
  set :temperature_db, db[:temperature_db]
end

run App
