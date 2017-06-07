class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :breed

  scope :by_businesses, -> (business_ids){
    joins(user: [:clientships])
    .where('business_id IN (?)', business_ids) unless business_ids.empty?
  }

  scope :by_kind, -> (kind){
    joins(:breed)
    .where('breeds.kind = ?', kind)
  }

  scope :by_top_breed, -> {
    joins(:breed)
    .group('breeds.id')
    .select('breeds.id, breeds.name, count(breeds.id) as breed_count')
    .order('breed_count desc')
    .limit(10)
  }
end
