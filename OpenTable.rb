require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  haml :upload
end

post "/" do 
  File.open('uploads/' + params[:myImage][:filename], "w") do |f|
    f.write(params['myImage'][:tempfile].read)
  end
  return "The file was successfully uploaded!"
end


