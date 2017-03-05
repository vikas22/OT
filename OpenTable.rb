require 'rubygems'
require 'sinatra'
require 'haml'
require 'aws-sdk'


REGION = 'ap-southeast-1'
ACCESS_KEY = 'AKIAJA3OKAAP6QCTAZYA'
ACCESS_SEC = '2xmZ0ejJsOsfkaOI/ptX8bLNIercOCpmvgXDzv+g'
BUCKET = 'otimagestest'
BUCKET_FOLDER = 'images'
S3_URL = "https://s3-ap-southeast-1.amazonaws.com/" + BUCKET + "/"
REGEX = "images\/.+"
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
	obj = S3.bucket(BUCKET).object(BUCKET_FOLDER + "/" + params['myImage'][:filename])
	obj.upload_file(params['myImage'][:tempfile])
	redirect "images"
end

get '/images' do 
	images = S3.bucket(BUCKET).objects.select{|x| !is_image?(x.key)}
	haml :images, :locals => {:bucket => images, :url => S3_URL }
end

def is_image?(key)
	key.match(REGEX).nil?
end


