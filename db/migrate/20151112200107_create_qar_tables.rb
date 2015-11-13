class CreateQarTables < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.integer :poll_id, null: false
    end

    create_table :answer_choices do |t|
      t.string :text, null: false
      t.integer :question_id, null: false
    end

    create_table :responses do |t|
      t.integer :answer_choice_id, null: false
      t.integer :user_id, null: false
    end

    add_index(:questions, :poll_id)
    add_index(:answer_choices, :question_id)
    add_index(:responses, :answer_choice_id)
    add_index(:responses, :user_id)   #revisit
    add_index(:responses, [:answer_choice_id, :user_id], unique: true)

  end
end
