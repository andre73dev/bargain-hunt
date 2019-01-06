class RakutenLatestItem < ActiveRecord::Base
#  has_many :genres , foreign_key: :genre_id, primary_key: :genres_id
  def calc_price_per_past_price
    if (item_price_past != 0)
      return ((item_price_past - item_price) * 100 / item_price_past).to_s.to_d.floor(1).to_s + "% DOWN"
    else
      return "[計算不能]"
    end
  end  
end
