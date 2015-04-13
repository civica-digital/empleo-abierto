class ResultsController < ApplicationController
  def index
  	@institutions = Institution.all
  	@jobs = Job.where(available: true).order(:institution_id).page params[:page]
  end

  def search
  	if params[:salary].strip.length > 0
  		@var = params[:salary]
  	end
  end
end
