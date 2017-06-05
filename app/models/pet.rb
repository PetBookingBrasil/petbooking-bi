class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :breed

  scope :by_businesses, -> (business_ids){
    joins(:user)
    joins(:clientship)
    .where('clientships.business_id IN (?)', business_ids) unless business_ids.empty?
  }

  scope :by_kind, -> (kind){
    joins(:breed)
    .where('breeds.kind = ?', kind)
  }
end
