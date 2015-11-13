class CreatePoll < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, null: false
      t.integer :author, null: false
    end

    add_index(:polls, :author)
  end
end
