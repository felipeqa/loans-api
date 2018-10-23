class Loan < ApplicationRecord
  validates_presence_of %I[name cpf total_loans quantity_quotas]
  validates :total_loans, numericality: true
  validates :quantity_quotas, numericality: { only_integer: true }
end
