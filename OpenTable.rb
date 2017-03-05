require 'rubygems'
require 'sinatra'
require 'haml'
require 'aws-sdk'


REGION = 'ap-southeast-1'
ACCESS_KEY = 'YOUR_KEY'
ACCESS_SEC = 'YOUR_SECRET'
BUCKET_FOLDER = 'images'

Aws.config.update({
  region: REGION,
  credentials: Aws::Credentials.new(ACCESS_KEY, ACCESS_SEC)
})

S3 = Aws::S3::Resource.new(region: REGION)

get '/' do
  haml :upload
end

post "/" do 
	puts params
	obj = S3.bucket('otimagestest').object(BUCKET_FOLDER + "/" + params['myImage'][:filename])
	obj.upload_file(params['myImage'][:tempfile])
end


