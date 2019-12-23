require_relative '../service'
class CheckAcl < Service
  def call(obj_acl)
    obj_acl.grants.any? do |grant|
     !!grant.grantee.uri.to_s.match(/AllUsers/)
    end
  end
end
