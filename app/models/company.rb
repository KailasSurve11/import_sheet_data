class Company < ActiveRecord::Base
	has_many :employees, dependent: :destroy
	validates_presence_of :company_name, :company_address

	validates_uniqueness_of :company_name, :company_address

end
