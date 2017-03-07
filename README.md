# OT
Open Table Assignment. [Demo](http://opentabletest.heroku.com/)

The project deals with uploading an image to S3 bucket and creating a thumbnail for a uploaded image using AWS Lambda.

* Ruby code deals with upload and UI part. Uploads to s3 bucket images folder
* Python code for [lambda](https://github.com/vikas22/OT/tree/master/lambda) function, triggered on every upload to s3 omgimagestest bucket, reads the uploaded image, creates thumbnail of it and uploads the same bucket, thumbnail folder

### Design

![Design](https://github.com/vikas22/OT/blob/master/arc/arc.jpg)
