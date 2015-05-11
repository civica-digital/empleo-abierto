#app/controllers/results_controller.rb
#This is the controller that manages the logic of the application for the index and for the search
class ResultsController < ApplicationController
  
  #Here we find all the available jobs, and also find the different KPIs
  def index
  	max_jobs = 0
    max_institution = 0
    @institutions = Institution.all
  	@jobs = Job.where(available: true)
    @total = @jobs.count #We calculate the total amount of available jobs

    #Here we check the institution with the maximum amount of available jobs
    @institutions.each do |i|
      j = Job.where(available: true, institution_id: i.id)
      if j.count > max_jobs then
        max_jobs = j.count
        max_institution = i
      end
    end
    @max_institution = max_institution.name #We take the name of the intitution with the most jobs
    highest_job = @jobs.order(:salary).last #We get the job with the highest salary
    @max_salary = highest_job.salary #We take the salary of that job
    @jobs = @jobs.order(:institution_id).page params[:page] #We send the jobs per page with the help of the "kaminari" gem
  end

  #This action is called after performing a search with the filters
  #Here we check the parameters received and then return the @jobs variable with the jobs found
  #The method is a little bit messy because it checks all the possibilities when you receive different number of parameters
  #If more options were added to the filters then this part needs to change and make it easier to maintain
  def search
  	@institutions = Institution.all
  	
    #If we received the job parameter
    if params[:job].strip.length > 0 
      if params[:institution].strip.length > 0 #If we received the institution parameter and the job parameter
        if params[:salary] == "1" #If we received the institution parameter and the job parameter and the salary option 1
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "2" #If we received the institution parameter and the job parameter and the salary option 2
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "3" #If we received the institution parameter and the job parameter and the salary option 3
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "4" #If we received the institution parameter and the job parameter and the salary option 4
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%")
        else #If we received the institution parameter and the job parameter but no salary parameter
          @jobs = Job.where(available: true, institution_id: params[:institution]).where("name ILIKE ?", "%#{params[:job]}%")
        end
      else #If we received the job parameter but not the institution parameter
        if params[:salary] == "1" #If we received the job parameter and the salary option 1 but not the institution parameter
          @jobs = Job.where(available: true, salary: 0..5000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "2" #If we received the job parameter and the salary option 2 but not the institution parameter
          @jobs = Job.where(available: true, salary: 5000..10000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "3" #If we received the job parameter and the salary option 3 but not the institution parameter
          @jobs = Job.where(available: true, salary: 10000..20000).where("name ILIKE ?", "%#{params[:job]}%")
        elsif params[:salary] == "4" #If we received the job parameter and the salary option 4 but not the institution parameter
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY).where("name ILIKE ?", "%#{params[:job]}%")
        else #If we received the job parameter only
          @jobs = Job.where(available: true).where("name ILIKE ?", "%#{params[:job]}%")
        end
      end
    
    #If we didn't receive the job parameter
    else
      if params[:institution].strip.length > 0 #If we received the institution parameter
        if params[:salary] == "1" #If we received the institution parameter and the salary option 1
    		  @jobs = Job.where(available: true, institution_id: params[:institution], salary: 0..5000)
        elsif params[:salary] == "2" #If we received the institution parameter and the salary option 2
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 5000..10000)
        elsif params[:salary] == "3" #If we received the institution parameter and the salary option 3
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 10000..20000)
        elsif params[:salary] == "4" #If we received the institution parameter and the salary option 4
          @jobs = Job.where(available: true, institution_id: params[:institution], salary: 20000..Float::INFINITY)
        else #If we received the institution parameter only
          @jobs = Job.where(available: true, institution_id: params[:institution])
        end
    	else #If we only received the salary parameter
        if params[:salary] == "1" #The salary option 1
          @jobs = Job.where(available: true, salary: 0..5000)
        elsif params[:salary] == "2" #The salary option 2
          @jobs = Job.where(available: true, salary: 5000..10000)
        elsif params[:salary] == "3" #The salary option 3
          @jobs = Job.where(available: true, salary: 10000..20000)
        elsif params[:salary] == "4" #The salary option 4
          @jobs = Job.where(available: true, salary: 20000..Float::INFINITY)
        else #If we didn't receive any parameters, we just return all the available jobs
          @jobs = Job.where(available: true)
        end
    	end
    end
    @total = @jobs.count #We return the total number of jobs found
    @jobs = @jobs.order(:institution_id).page params[:page] #We send the jobs per page using the "kaminari" gem
  end
end
