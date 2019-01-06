class CreateRakutenLatestItems < ActiveRecord::Migration
  def change
    create_table :rakuten_latest_items do |t|
      t.string :item_code
      t.string :item_name      
      t.string :small_image1
      t.string :small_image2
      t.string :small_image3
      t.string :medium_image1
      t.string :medium_image2
      t.string :medium_image3
      t.decimal :item_price
      t.integer :rank
      t.string :item_caption
      t.string :item_url
      t.string :genre_root_id
      t.string :genre_root_name
      t.string :genre_id
      t.string :genre_name
      t.string :shop_code
      t.string :shop_name
      t.string :shop_url
      t.integer :rank_past
      t.decimal :item_price_past
      t.datetime :item_update_past
      t.decimal :down_rate

      t.timestamps null: false
    end
  end
end
