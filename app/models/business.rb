class Business < ApplicationRecord
  has_many :employments
  has_many :clientships
  has_many :reviews, through: :clientships
  has_ancestry

  AASM_STATES = {
    disabled: 0, wizard_0: 1, wizard_1: 2, wizard_2: 3, wizard_3: 4, wizard_4: 5,
    wizard_5: 6, wizard_6: 7, wizard_7: 8, ready: 9, enabled: 10
  }

  scope :active, -> {
    where(aasm_state: AASM_STATES[:enabled])
  }

  scope :between, ->(start_date, end_date){
    where('created_at >= ? AND created_at <= ?', start_date, end_date)
  }

  scope :imported, -> (boolean) {
    where('imported = ?', boolean)
  }

  scope :by_step, -> (step) {
    where(aasm_state: step)
  }

  #scope :by_businesses, -> (business_ids){
  #  joins(:clientships)
  #  .where('clientships.business_id IN (?)', business_ids) unless business_ids.empty?
  #}
end
