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
REGEX_THUMB = "thumbnails\/.+"
Aws.config.update({
  region: REGION,
  credentials: Aws::Credentials.new(ACCESS_KEY, ACCESS_SEC)
})

S3 = Aws::S3::Resource.new(region: REGION)

get '/' do
  erb :'upload'
end

post "/" do 
	puts params

	obj = S3.bucket(BUCKET).object(BUCKET_FOLDER + "/" + params['myImage'][:filename])
	obj.upload_file(params['myImage'][:tempfile])
	redirect "images"
end

get '/images' do 

	imagesArr= (S3.bucket(BUCKET).objects.select{|x| !is_image?(x.key)})
	imagesHash =  imagesArr.group_by{|x| x.last_modified.strftime("%m/%d/%Y")}
	erb :images, :locals => {:images => imagesHash, :url => S3_URL }
end

get '/thumbnails' do 

	imagesArr= (S3.bucket(BUCKET).objects.select{|x| !is_thumbnail?(x.key)})
	imagesHash =  imagesArr.group_by{|x| x.last_modified.strftime("%m/%d/%Y")}
	erb :thumbnails, :locals => {:images => imagesHash, :url => S3_URL }
end


def is_image?(key)
	key.match(REGEX).nil?
end

def is_thumbnail?(key)
	key.match(REGEX_THUMB).nil?
end

