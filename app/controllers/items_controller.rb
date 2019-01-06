class ItemsController < ApplicationController
  def index
    @items = RakutenLatestItem.page(params[:page]).order('down_rate desc,rank_past')
  end
  
  #.joins(:genres).eager_load
  # https://qiita.com/akishin/items/36dba4b2ccdaefb53dc6
  
  #ジャンルごとのバーゲン商品を表示、率順、ランク順、日付順(10行ずつ)
  #全ジャンルのバーゲントップ３だけ表示して並べる
  #ジャンル別のTOP10を日付ごとに並べる
  #

  #参考 bootstrap上でのページネーション
  #https://qiita.com/manemone@github/items/564c58ea59fb3450826c
  #参考 自動ページ送り
  #
  
  #slim 
  # https://qiita.com/mom0tomo/items/999f806d083569529f81
  # https://github.com/slim-template/slim/blob/master/README.jp.md
end
