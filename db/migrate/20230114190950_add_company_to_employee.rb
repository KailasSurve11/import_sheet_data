class AddCompanyToEmployee < ActiveRecord::Migration
  def change
    add_reference :employees, :company, foreign_key: true
  end
end
