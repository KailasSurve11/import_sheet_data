class Employee < ActiveRecord::Base
	belongs_to :Company 
	validates_presence_of :name, :gender, :email, :age, :contact_no
	validates_uniqueness_of :email, case_sensitive: false
	
end
