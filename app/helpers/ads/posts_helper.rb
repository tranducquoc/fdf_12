module Ads::PostsHelper
  def rebuild_param hash, rebuild_value
    new_attributes = Hash.new
    hash.each do |key, value|
      real_key ||= key
      real_key = real_key.to_i
      if value[rebuild_value]
        value[rebuild_value].each do |image|
          new_attributes["#{real_key}"] = {_destroy: false}
          new_attributes["#{real_key}"] = {"#{rebuild_value}": image}
          real_key += 1
        end
      end
    end
    new_attributes
  end
end
