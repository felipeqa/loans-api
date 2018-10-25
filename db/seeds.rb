# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  total_loans = Faker::Number.decimal(4).to_f
  quantity_quotas = Faker::Number.between(1, 10)
  quota_value = (total_loans / quantity_quotas).round(2)
  Loan.create(
    name: Faker::Name.name_with_middle,
    cpf: Faker::CPF.numeric,
    total_loans: total_loans,
    quantity_quotas: quantity_quotas,
    quota_value: quota_value
  )
end

User.create(
  email: 'admin@admin.com',
  password: 'password',
  username: 'ADMIN',
  role: 'admin'
)
