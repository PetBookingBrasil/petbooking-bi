class SalesOrder < ApplicationRecord
  has_many :sales_items, dependent: :destroy
end
