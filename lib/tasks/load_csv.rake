namespace :load_csv do

  require 'csv'
  
  filename = 'lib/datasets/directorioPot.csv'
  filename2 = 'lib/datasets/puestoAPF.csv'

  desc "Load csv into the database"
  task task1: :environment do
  	ActiveRecord::Base.transaction do
	  	CSV.foreach(filename, :headers => true) do |row|
			unless Institution.exists?(name: row['Institución'].strip) then
				Institution.create!(name: row['Institución'].strip, telephone: row['Conmutador'].strip, extension: row['Extensión'].strip)
			end
		end
	end
  end

  task task2: :environment do
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
  end

  task task3: :environment do
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
  end

  task task4: :environment do
  	destination = "db/seeds.rb"
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
