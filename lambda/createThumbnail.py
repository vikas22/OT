import boto3
import os
from PIL import Image, ImageOps
import urllib2 as urllib
import io
import re

URL = "https://s3-ap-southeast-1.amazonaws.com/otimagestest/"
REGEX = "images\/.+"
maxWidth = 100
maxHeight = 100
fixRatio = 1
ACCESS_KEY = "xxx"
ACCESS_SEC = "xxx"
BUCKET = 'otimagestest'

def imageResize(key):
    print(URL + key)
    fd = urllib.urlopen(URL + key )
    image_file = io.BytesIO(fd.read())
    img = Image.open(image_file)
    nHeight = maxHeight
    nWidth = maxWidth

    height = int(img.size[1]) 
    width =  int(img.size[0]) 
    ratio = float(height / width)
    maxRatio  = float(maxHeight / maxWidth)

    if ratio > maxRatio :
      x = int(width * nHeight / height)
      if x < nWidth :
        nHeight = int(height * nWidth / width)
      else:
        nWidth = x
    else:
      x = int(height * nWidth / width)
      if x < nHeight :
        nWidth = int(width * nHeight / height)
      else:
        nHeight = x
        

    if nWidth > 640 :
      nWidth = 640

    if nHeight > 480 :
      nHeight = 480

    size = nWidth , nHeight
    print(nWidth)
    print(nHeight)
    img.thumbnail(size, Image.ANTIALIAS)
    newKey = str(key).replace("images/","")
    img.save('/tmp/'+ newKey)
    s3 = boto3.client('s3')
    s3 = boto3.resource('s3',
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=ACCESS_SEC)
    s3.meta.client.upload_file('/tmp/'+ newKey, BUCKET, "thumbnails/" + newKey)
    os.remove("/tmp/" + newKey)

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        if(re.match(REGEX, key)):
            imageResize(key)
