require 'aws-sdk'
require_relative '../service'
require_relative '../services/check_acl'

class OpenBuckets < Service
  def call(access_key:, secret:)
    @access_key, @secret = access_key, secret
    collect_data
  rescue => e
    puts e
    []
  end

  def client
    @client ||= Aws::S3::Resource.new(
     credentials: Aws::Credentials.new(@access_key, @secret),
     region: 'eu-central-1'
    )
  end

  def collect_data
    buckets = client.buckets.map do |b|
      region = client.client.get_bucket_location(bucket: b.name).location_constraint
      s3tempclient = Aws::S3::Resource.new(
       credentials: Aws::Credentials.new(@access_key, @secret),
       region: region
     )
     status = CheckAcl.call(s3tempclient.client.get_bucket_acl({bucket: b.name}))

     bucket = Bucket.new(b.name, region, status, s3tempclient.client, [])

     s3tempclient.bucket(b.name).objects.each do |obj|
       bucket.keys << obj.key
     end

     bucket
   end
  end

  Bucket = Struct.new(:name, :region, :public, :client, :keys)
end
