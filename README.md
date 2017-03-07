# OT
Open Table Assignment. [Demo](http://opentabletest.heroku.com/)

Project deals with uploading an image to S3 buckent and creating thumbnail of every uploaded image using AWS Lambda.

* Ruby code deals with upload and UI part. Uploads to s3 bucket image folder
* Python code for [lambda](https://github.com/vikas22/OT/tree/master/lambda) fuction, triggered on every upload to s3, gets the uploaded image, creates thumbnail of it and uploads to same bucket, thumbnail folder


### Design

![Design](https://github.com/vikas22/OT/blob/master/arc/arc.jpg)
