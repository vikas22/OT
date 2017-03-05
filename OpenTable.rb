require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :upload
end

post "/" do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  return "The file was successfully uploaded!"
end


