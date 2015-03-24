class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :telephone
      t.string :extension

      t.timestamps null: false
    end
  end
end
