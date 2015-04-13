class ResultsController < ApplicationController
  def index
  	@institutions = Institution.all
  	@jobs = Job.where(available: true).order(:institution_id).page params[:page]
  end

  def search
  	@institutions = Institution.all
  	if params[:institution].strip.length > 0
  		@jobs = Job.where(available: true, institution_id: params[:institution]).order(:institution_id).page params[:page]
  	else
  		@jobs = Job.where(available: true).order(:institution_id).page params[:page]
  	end
  end
end
