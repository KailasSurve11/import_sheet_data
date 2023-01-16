class EmployeesController < ApplicationController
	before_action :get_company
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index  	
    @employees = @company.employees.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new  	
    @employee = @company.employees.build
  end

  # GET /employees/1/edit
  def edit
  end

  def import_sheet
    # file = params[:file]
    # begin
    #   file_ext = File.extname(file.original_filename)
    #   raise "Unknown file type: #{file.original_filename}" unless [".xls", ".xlsx"].include?(file_ext)
    #   spreadsheet = (file_ext == ".xls") ? Roo::Excel.new(file.path) : Roo::Excelx.new(file.path)
    #   header = spreadsheet.row(1)
    #   ## We are iterating from row 2 because we have left row one for header
    #   (2..spreadsheet.last_row).each do |i|
    #     User.create(first_name: spreadsheet.row(i)[0], last_name: spreadsheet.row(i)[1])
    #   end
    #   flash[:notice] = "Records Imported"
    #   redirect_to users_path 
    # rescue Exception => e
    #   flash[:notice] = "Issues with file"
    #   redirect_to users_path 
    # end
 		# file = params[:xml_file]
   #  xlsx = Roo::Spreadsheet.open(file, extension: :xlsx)
   #  count = xlsx.count
   #  for i in 1...count do
   #    name = xlsx.row(i+1)[0]
   #    gender = xlsx.row(i+1)[1]
   #    email = xlsx.row(i+1)[2]
   #    age = xlsx.row(i+1)[3]
   #    contact_no = xlsx.row(i+1)[4]

   #    @employee_data = Employee.new(name: name,   gender: gender, age: age, email:email, contact_no:contact_no)
   #    @employee_data.save
   #  end
   #  redirect_to root_path
		puts 'Importing Data'
		file = params[:xml_file]
		@employee_errors = [];
    data = Roo::Spreadsheet.open(file, extension: :xlsx) # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
    	
      next if idx == 0 # skip header row
      # create hash from headers and cells
      employee_params = Hash[[headers, row].transpose]
      # next if user exists
      if Employee.exists?(email: employee_params['email'])
        @employee_errors << "User with email #{employee_params['email']} already exists"
        next
      end
      
      @employee = @company.employees.build(employee_params)
      puts "Saving User with email '#{@employee.email}'"
     	@employee.save
   		# else
   		# 	format.html { render :new }
     #    format.json { render json: @employee.errors, status: :unprocessable_entity }
   		# end

    end

    if @employee_errors	    
    	flash.now[:danger] = "Error Detected in the header of the Spreadsheet. Please read the instructions."
    	redirect_to company_employees_path(@company)
    else
    	redirect_to company_employees_path(@company)
    end  

 	end

  # POST /employees
  # POST /employees.json
  def create
    @employee = @company.employees.build(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to company_employees_path(@company), notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to company_employees_path(@company), notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to company_employees_path(@company), notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  	def get_company
	    @company = Company.find(params[:company_id])
	  end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = @company.employees.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name, :gender, :email, :age, :contact_no)
    end
end
