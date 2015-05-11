#lib/tasks/load_csv.rake
#This file contains the task that reads the .csv files and then inserts the data into the database.
#After filling the database, it loads the file db/seeds.rb with all the information.

namespace :load_csv do

  require 'csv'
  
  filename = 'lib/datasets/directorioPot.csv'
  filename2 = 'lib/datasets/puestoAPF.csv'
  destination = "db/seeds.rb"

  desc "Load csv into the database and fill the seeds.rb file"

    #The task is divided into 4 main sections which will be explained below.
    task task1: :environment do
    
    #This is the first section
    #In here we read the first file and all the Institutions are created in case they don't exist.
    ActiveRecord::Base.transaction do
      CSV.foreach(filename, :headers => true) do |row|
      unless Institution.exists?(name: row['Institución'].strip) then
        Institution.create!(name: row['Institución'].strip, telephone: row['Conmutador'].strip, extension: row['Extensión'].strip)
      end
      end
    end


    #This is the second section
    #In here we read the first file again, but this time the jobs are created and associated to a Institution.
    #The jobs are created with a salary of 0 because the salary is in the other file.
    ActiveRecord::Base.transaction do
      CSV.foreach(filename, :headers => true) do |row|
      @ins = Institution.find_by name: row['Institución'].strip
      unless @ins.jobs.exists?(name: row['Nombre del Cargo'].strip) then
        if row['Tipo de Vacancia'].strip.length > 0 and  !row['Tipo de Vacancia'].downcase.include? "no" then
          @ins.jobs.create!(name: row['Nombre del Cargo'].strip, key: row['Clave del Puesto/Remuneración Salarial'].strip, job_type: row['Tipo de Personal'].strip, salary: 0, compensation: 0, available: true)
        else
          @ins.jobs.create!(name: row['Nombre del Cargo'].strip, key: row['Clave del Puesto/Remuneración Salarial'].strip, job_type: row['Tipo de Personal'].strip, salary: 0, compensation: 0, available: false)
        end
      end
      end
    end


    
    #This is the third section
    #In here we read the second file to associate a salary with each job.
    ActiveRecord::Base.transaction do
      CSV.foreach(filename2, :headers => true) do |row|
      if Institution.exists?(name: row['Institucion'].strip) then
        @ins = Institution.find_by name: row['Institucion'].strip
        if @ins.jobs.exists?(key: row['Clave del Puesto'].strip) then
          @jobs = Job.where :institution => @ins, :key => row['Clave del Puesto'].strip
          @jobs.each do |job|
            job.update(salary: row['Sueldo Base/ Salario Ordinario'].strip.to_f, compensation: row['Compensación'].strip.to_f)
          end
        end
      end
    end
  end



    #This is the fourth section
    #In here we read the data from all the Institutions and all the Jobs to load that data into the db/seeds.rb file.
    #We load the data in SQL to make it faster when populating the staging/production database.
    institutions = Institution.all
    jobs = Job.all
    File.open(destination, "w") do |f|
      f.puts "Institution.transaction do"
      institutions.each do |i|
        f.puts "Institution.connection.execute \"INSERT INTO institutions (id, name, telephone, extension, created_at, updated_at) values (#{i.id}, \'#{i.name}\', \'#{i.telephone}\', \'#{i.extension}\', \'#{i.created_at}\', \'#{i.updated_at}\')\""
      end
      f.puts "end"

      f.puts "Job.transaction do"
      jobs.each do |j|
        f.puts "Job.connection.execute \"INSERT INTO jobs (id, name, key, job_type, salary, compensation, available, institution_id, created_at, updated_at) values (#{j.id}, \'#{j.name}\', \'#{j.key}\', \'#{j.job_type}\', #{j.salary}, #{j.compensation}, #{j.available}, #{j.institution_id}, \'#{j.created_at}\', \'#{j.updated_at}\')\""
      end
      f.puts "end"
    end

  end

end
