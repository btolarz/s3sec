require_relative '../service'
require_relative '../services/check_acl'

class PublicFiles < Service
  def call(bucket, extentions, tick = nil)
    bucket.keys.reduce([]) do |arr, key|
      tick.call if tick
      arr << File.new(key, bucket) if extentions.include?(key.split('.').last) &&
                                      CheckAcl.call(bucket.client.get_object_acl({bucket: bucket.name, key: key}))
      arr
    end
  rescue => e
    puts e
    []
  end

  File = Struct.new(:key, :bucket)
end
