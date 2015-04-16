class ResultsController < ApplicationController
  def index
  	max_jobs = 0
    max_institution = 0
    @institutions = Institution.all
  	@jobs = Job.where(available: true)
    @total = @jobs.count

    @institutions.each do |i|
      j = Job.where(available: true, institution_id: i.id)
      if j.count > max_jobs then
        max_jobs = j.count
        max_institution = i
      end
    end
    @max_institution = max_institution.name
    highest_job = @jobs.order(:salary).last
    @max_salary = highest_job.salary
    @jobs = @jobs.order(:institution_id).page params[:page]
  end

  def search
  	@institutions = Institution.all
  	
    if params[:job].strip.length > 0
      if params[:institution].strip.length > 0
        if params[:salary] == "1"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%")
        else
          @jobs = Job.where(available: true, institution_id: params[:institution]).where("name ILIKE ?", "%#{params[:job]}%")
        end
      else
        if params[:salary] == "1"
          @jobs = Job.where(available: true, salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%")
        else
          @jobs = Job.where(available: true).where("name ILIKE ?", "%#{params[:job]}%")
        end
      end
    else
      if params[:institution].strip.length > 0
        if params[:salary] == "1"
    		  @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000)
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000)
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000)
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY)
        else
          @jobs = Job.where(available: true, institution_id: params[:institution])
        end
    	else
        if params[:salary] == "1"
          @jobs = Job.where(available: true, salary: 0..5000)
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, salary: 5000..10000)
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, salary: 10000..20000)
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY)
        else
          @jobs = Job.where(available: true)
        end
    	end
    end
    @total = @jobs.count
    @jobs = @jobs.order(:institution_id).page params[:page]
  end
end
