class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :genres_id
      t.string :genres_name

      t.timestamps null: false
    end
  end
end
