require 'sinatra/base'
require 'digest'
require 


class App < Sinatra::Base
  get "/" do
    "hello world"
  end

  get "/temperature/:apiKey" do
     if '80a13a67f485849a3ba8d80dbe87e029886cb90fd6c74a34de00aceb1afe795b26f5cd0743f5c19f1caf239037bd5b3e4047c8201ce5b9167c5111901acc9321' == Digest::SHA512.hexdigest(params['apiKey']).to_s

     else
       403
     end
  end

  error 403 do
    'Access forbidden'
  end

end
