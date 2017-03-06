class CreateOpenTickets < ActiveRecord::Migration
  def change
    create_table :open_tickets do |t|
      t.string :product, null: false
      t.string :issue, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :ticket_id, null: false
  
      t.timestamps null: false
    end
  end
end
