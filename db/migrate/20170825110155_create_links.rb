class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :original_url
      t.string :shorten_url

      t.timestamps null: false
    end
  end
end
