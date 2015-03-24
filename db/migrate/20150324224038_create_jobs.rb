class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :key
      t.string :type
      t.float :salary
      t.float :compensation
      t.boolean :available
      t.references :institution, index: true

      t.timestamps null: false
    end
    add_foreign_key :jobs, :institutions
  end
end
