class ResultsController < ApplicationController
  def index
  	@institutions = Institution.all
  	@jobs = Job.where(available: true).order(:institution_id).page params[:page]
  end

  def search
  	@institutions = Institution.all
  	
    if params[:job].strip.length > 0
      if params[:institution].strip.length > 0
        if params[:salary] == "1"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        else
          @jobs = Job.where(available: true, institution_id: params[:institution]).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        end
      else
        if params[:salary] == "1"
          @jobs = Job.where(available: true, salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        else
          @jobs = Job.where(available: true).where("name ILIKE ?", "%#{params[:job]}%").order(:institution_id).page params[:page]
        end
      end
    else
      if params[:institution].strip.length > 0
        if params[:salary] == "1"
    		  @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000).order(:institution_id).page params[:page]
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000).order(:institution_id).page params[:page]
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000).order(:institution_id).page params[:page]
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY).order(:institution_id).page params[:page]
        else
          @jobs = Job.where(available: true, institution_id: params[:institution]).order(:institution_id).page params[:page]
        end
    	else
        if params[:salary] == "1"
          @jobs = Job.where(available: true, salary: 0..5000).order(:institution_id).page params[:page]
        elsif params[:salary] == "2"
          @jobs = Job.where(available: true, salary: 5000..10000).order(:institution_id).page params[:page]
        elsif params[:salary] == "3"
          @jobs = Job.where(available: true, salary: 10000..20000).order(:institution_id).page params[:page]
        elsif params[:salary] == "4"
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY).order(:institution_id).page params[:page]
        else
          @jobs = Job.where(available: true).order(:institution_id).page params[:page]
        end
    	end
    end
  end
end
