class CreateLinkVisits < ActiveRecord::Migration
  def change
    create_table :link_visits do |t|
      t.integer :count
      t.integer :link_id

      t.timestamps null: false
    end
  end
end
