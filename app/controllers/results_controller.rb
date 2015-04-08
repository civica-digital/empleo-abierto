class ResultsController < ApplicationController
  def index
  	@jobs = Job.where(available: true).order(:institution_id).page params[:page]
  end
end
