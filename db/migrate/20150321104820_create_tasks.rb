class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true
      t.string :title
      t.string :memo
      t.string :aasm_state

      t.timestamps null: false
    end
    add_foreign_key :tasks, :users
  end
end
