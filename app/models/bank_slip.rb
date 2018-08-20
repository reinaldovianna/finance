class BankSlip < ApplicationRecord
  has_and_belongs_to_many :channel_stores

end
