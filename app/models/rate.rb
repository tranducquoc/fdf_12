class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension
  scope :by_shop_id, -> id{where rateable_type: Shop.name, rateable_id: id}

  def update_rating_cache
    rates = Rate.by_shop_id self.rateable_id
    rating_cache = RatingCache.find_or_initialize_by cacheable_type: self.rateable_type, cacheable_id: self.rateable_id
    rating_cache.qty = rates.size
    rating_cache.avg = rates.inject(0){|sum, n| sum + n.stars} * 1.0 / rates.size
    rating_cache.save
  end
end
