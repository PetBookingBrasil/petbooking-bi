class Clientship < ActiveRecord::Base
  belongs_to :business
  belongs_to :user
  has_many :events
  has_many :reviews, through: :events

  scope :by_businesses, -> (business_ids){
    where('clientships.business_id IN (?)', business_ids) unless business_ids.empty?
  }
end
