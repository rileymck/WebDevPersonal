class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :school_email, null: false
      t.string :major
      t.string :minor
      t.date :graduation_date

      t.timestamps
    end
  end
end
