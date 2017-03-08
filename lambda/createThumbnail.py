from __future__ import division
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
    fd = urllib.urlopen(URL + key)
    image_file = io.BytesIO(fd.read())
    img = Image.open(image_file)
    nHeight = maxHeight
    nWidth = maxWidth

    height =  int(img.size[1])
    width = int(img.size[0])

    print(height)
    print(width)

    nWidth = int(float((width * maxHeight) / height))
    nHeight =int(float(height * maxWidth / width))

    print(nWidth)
    print(nHeight)

    if nWidth > maxWidth :
      nWidth = maxWidth

    if nHeight > maxHeight :
      nHeight = maxHeight

    print(nWidth)
    print(nHeight)
    size = nWidth , nHeight
    img = img.resize(size, Image.ANTIALIAS)
    newKey = str(key).replace("images/","")
    img.save('/tmp/'+ newKey)
    s3 = boto3.client('s3')
    s3 = boto3.resource('s3',
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=ACCESS_SEC)
    s3.meta.client.upload_file('/tmp/'+ newKey, BUCKET, "thumbnails/" + newKey, ExtraArgs={'ContentType': fd.info().getheader('x-amz-meta-content-type')})
    os.remove("/tmp/" + newKey)



def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        if(re.match(REGEX, key)):
            imageResize(key)
