class Loan < ApplicationRecord
  validates_presence_of %I[name cpf total_loans quantity_quotas]
  validates :total_loans, numericality: true
  validates :quantity_quotas, numericality: { only_integer: true }

  # Custom validates
  validate :value_most_be_greater_than_zero

  def value_most_be_greater_than_zero
    if total_loans < 1
      errors.add(:total_loans, "Total Loans should be most be greater than zero")
    elsif quantity_quotas < 1
      errors.add(:quantity_quotas, "Quantity Quotas should be most be greater than zero")
    end
  end
end
