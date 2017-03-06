class CreateStaffResponses < ActiveRecord::Migration
  def change
    create_table :staff_responses do |t|
      t.string :staff_username, null: false
      t.string :response_message, null: false
      t.string :ticket_id, null: false
  
      t.timestamps null: false
    end
  end
end
