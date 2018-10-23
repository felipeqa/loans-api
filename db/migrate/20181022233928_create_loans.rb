class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.string :name
      t.string :cpf
      t.float :total_loans
      t.integer :quantity_quotas
      t.float :quota_value

      t.timestamps
    end
  end
end
