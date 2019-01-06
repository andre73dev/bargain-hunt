namespace :rakuten_item do
#  require 'nokogiri'
  require 'kconv'
#  require 'anemone'

  desc '楽天の商品情報をセットする'

  #ジャンルの最新情報をセットする  
  task :dataset_genre => :environment do
    root_genres = RakutenWebService::Ichiba::Genre.root #ルートのみ

    root_genres.children.each do |child_genre|

      #ジャンル毎のランキングと商品情報をセット
      setRakutenGenreData(child_genre)
    
    end  
  end

  #全カテゴリのTop30商品をセットする  
  task :dataset => :environment do
    root_genres = RakutenWebService::Ichiba::Genre.root

#begin
    root_genres.children.each do |child_genre|

#      p 'genres ' + "#{child_genre.id}"

      #ジャンル毎のランキングと商品情報をセット
      setRakutenItemData("#{child_genre.id}")
    end
#end
      #ジャンル毎のランキングと商品情報をセット
#      setRakutenItemData("112493")

  end

  #過去のTop30商品の最新情報をセットする  
  task :dataset_now => :environment do

    #sleep(3600)


    #過去の商品から最新の商品情報をセットする
    setRakutenItemData_lastest(3)
  end
  
  private
  
  #ジャンル情報を追加する
  def setRakutenGenreData(genre)
    _genre = Genre.new
    _genre.genres_id = "#{genre.id}"
    _genre.genres_name = "#{genre.name}"
    _genre.save
  end  

  #最新商品テーブルへ追加する
  def setRakutenItemData_lastest(months)
    #{months}月前の商品データを取得
    _item_codes = RakutenItem.find_by_sql(
#      ["select distinct(item_code) as item_code,rank,item_price,created_at from rakuten_items where created_at >= current_timestamp + '-? months'", months])
      ["select * from rakuten_items i inner join (select item_code,max(created_at) as created_at from rakuten_items group by item_code) im on i.item_code = im.item_code and i.created_at = im.created_at where i.created_at >= current_timestamp + '-? months'", months])

    if _item_codes 
      _item_codes.each do |_item|
#puts _item['genre_id']
#if _item['genre_root_id'] == "112493" || _item['genre_id'] == "208140" ||
#  _item['genre_id'] == "112136" ||  _item['genre_id'] == "566732" || 
#  _item['genre_id'] == "301981"  #test       
#puts _item['genre_id']
        begin
        
          #商品コードから商品情報を取得
          res = RakutenWebService::Ichiba::Item.search(itemCode: _item['item_code'])
          #商品情報の追加
          setItemData(res.first(1), _item['genre_root_id'], 'latest', _item)
        rescue => e
          puts e.message
        end
        
        sleep(1) #楽天のAPI制限対応
#end
      end  
    end
  end

  #特定ジャンルのランキングTOP30の商品情報を追加する
  def setRakutenItemData(genre_id)

    begin
      #ジャンル毎のランキングTOP30と商品情報を取得
      res = RakutenWebService::Ichiba::Item.ranking(genreId: genre_id)
      #商品情報の追加
      setItemData(res, genre_id, 'origin')
      
    rescue => e
      puts e.message
    end
    
    sleep(1) #楽天のAPI制限対応

  end
  
  def setItemData(data, genre_root_id, dest, item_past={})

#p 'rrr:' + data.to_s

    data.each do |rakuten_item|

      if dest == 'origin'
        item = RakutenItem.new
      else
        if (rakuten_item['itemPrice'].to_d < item_past['item_price'])
#        if (rakuten_item['genreId'] == rakuten_item['genreId']) #test
          item = RakutenLatestItem.new
        else
          next
        end
      end
      item.item_code = rakuten_item['itemCode']
      item.item_name = rakuten_item['itemName']

  
      if (rakuten_item['imageFlag'] == 1)
        item.small_image1 = rakuten_item['smallImageUrls'][0]
        if rakuten_item['smallImageUrls'].length >= 2 
          item.small_image2 = rakuten_item['smallImageUrls'][1]
        elsif rakuten_item['smallImageUrls'].length >= 3
          item.small_image3 = rakuten_item['smallImageUrls'][2]
        end

        item.medium_image1 = rakuten_item['mediumImageUrls'][0]
        if rakuten_item['smallImageUrls'].length >= 2 
          item.medium_image2 = rakuten_item['mediumImageUrls'][1]
        elsif rakuten_item['smallImageUrls'].length >= 3
          item.medium_image3 = rakuten_item['mediumImageUrls'][2]
        end
      end        
      item.item_price  = rakuten_item['itemPrice'].to_d
      item.rank  = rakuten_item['rank']
      item.item_caption = rakuten_item['itemCaption']
      item.item_url = rakuten_item['itemUrl']
      item.shop_code = rakuten_item['shopCode']
      item.shop_name = rakuten_item['shopName']
      item.shop_url = rakuten_item['shopUrl']

      #ランキング取得時
      if dest == 'origin'
        item.genre_root_id = genre_root_id
        item.genre_root_name = getGenreName(genre_root_id)
        item.genre_id = rakuten_item['genreId']
        item.genre_name = getGenreName(rakuten_item['genreId'])
      else 
      #最新情報更新時  
        if item_past.present?
          #過去情報から取得
          item.genre_root_id = item_past['genre_root_id']
          item.genre_root_name = item_past['genre_root_name']
          item.genre_id = item_past['genre_id']
          item.genre_name = item_past['genre_name']
          item.rank_past = item_past['rank']
          item.item_price_past = item_past['item_price']
          item.item_update_past = item_past['created_at']
          item.down_rate = item.calc_price_per_past_price() #値下率(%)
          
          puts item.item_name
          puts item.rank
          puts item.rank_past
          puts item.item_price
          puts item.item_price_past
        end
      end  
=begin
      puts item.item_code
      puts item.item_name  
      puts item.small_image1
      puts item.small_image2
      puts item.small_image3
      puts item.medium_image1
      puts item.medium_image2
      puts item.medium_image3
      puts item.item_price
      puts item.rank
      puts item.item_caption
      puts item.item_url
      puts item.genre
      puts item.shop_code
      puts item.shop_name
=end
      
      item.save
    end
  end
  
  #ジャンル名を取得する
  def getGenreName(genre_id)
    genre = Genre.find_by(genres_id: genre_id)
    
    if genre.present?
      genre_name = genre['genres_name']
    else  
    #取得できない場合はAPIから
      puts 'api use' + genre_id
      
      begin
        #ジャンル名の取得
        genre_name = RakutenWebService::Ichiba::Genre[genre_id.to_i].name

      rescue => e
        puts e.message
      end
      
      sleep(1) #楽天のAPI制限対応
    end
    
    return genre_name
  end
end

=begin
  #同じ商品が存在するか？
  #(１日前のみ参照)
  def exits_item?(asin)
    puts asin
    res = Item.find_by_sql(["select count(*) from items where asin = ? and created_at > (now() + '-2days');", asin])
    if res 
      "puts res.to_s
      #&& (res[0].to_i > 0
      return true
    else
      return false
    end  
  end

=begin
  アマゾンのスクレイピング対策でブロックされる
  def addContents(url, _item)
    opts = {
      depth_limit: 0,
      delay:4
    }

#puts url

    Anemone.crawl(url, opts) do |anemone|
      anemone.on_every_page do |page|
        # htmlをパース(解析)してオブジェクトを作成
        doc = Nokogiri::HTML.parse(page.body.toutf8)
        puts doc.to_s
        #_item.title = doc.xpath('//h1[@data-automation-id="title"]').text()
        #puts 'sssss:' + doc.xpath('//h1')
        _item.title = CGI.unescapeHTML(doc.xpath('//h1[@data-automation-id="title"]').text)#なぜか要素指定できない
        _item.contents = CGI.unescapeHTML(doc.xpath('//div[@data-automation-id="synopsis"]').text.gsub(/(\r\n?|\n)/,""))
        
        puts doc.xpath('//div[@data-automation-id="synopsis"]').to_s
        puts _item.contents
        
        #doc.xpath('//h1[@id="aiv-content-title"]').each do |node|
          #logger.debug('h1=' + h1.content.strip)
         # logger.debug('h1=' + node.content.strip)
          #return node.content.strip
         # title = node.xpath("./text()").to_s.strip
        #break
        #end
      end  
    end  

    return _item
    
  end
=end  
