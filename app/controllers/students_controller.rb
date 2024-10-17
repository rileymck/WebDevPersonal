class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    @search_params = params[:search] || {}
    @students = Student.all

    #"Show All" button shows all students
    if params[:show_all]
      @students = Student.all

    #Searches only if major or graduation date is filled out correctly
    elsif @search_params[:major].present? || @search_params[:graduation_date].present?
      #Filter by major is provided
      if @search_params[:major].present? && @search_params[:major] != "all"
        @students = @students.where(major: @search_params[:major])
      end
      #Filter by graduation date if the date and before/after is provided
      if @search_params[:grad_date_filter].present? && @search_params[:graduation_date].present?
      begin
        selected_date = Date.parse(@search_params[:graduation_date])
        Rails.logger.info "Parsed Date: #{selected_date}"

        if @search_params[:grad_date_filter] == 'before' && @search_params[:graduation_date].present?
          @students = @students.where("graduation_date < ?", @search_params[:graduation_date])
        elsif @search_params[:grad_date_filter] == 'after' && @search_params[:graduation_date].present?
          @students = @students.where("graduation_date > ?", @search_params[:graduation_date])
        end

      rescue ArgumentError
        #Return no results if date is invalid
        flash.now[:alert] = "Invalid date format" 
        @students = Student.none
      end
    end

  else
    #If no search feilds are filled, show an alert or show no students
    flash.now[:alert] = "Please provide at least one search criteria"
    @students = Student.none
  end

    Rails.logger.info "Search Params: #{@search_params.inspect}"
    Rails.logger.info "Resulting Students: #{@search.inspect}"
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :school_email, :major, :minor, :graduation_date, :profile_picture)
    end
end

