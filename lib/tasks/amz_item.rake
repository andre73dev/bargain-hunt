namespace :amz_item do
  require 'nokogiri'
  require 'kconv'
  require 'anemone'

  desc 'アマゾンの商品情報をセットする'

  #全カテゴリのTop10商品をセットする  
  task :dataset => :environment do

    search_indexs = 
    [361245011,2277725051,2017305051,344845011,52391051,
    465610,701040,562002,3210991,52231011,
    57240051,161669011,2277721051,2016929051,85895051,
    2250739051,3839151,2129039051,2381131051,562032,
    562032,2123630051,86732051,2127210051,2127213051,
    2016927051,637630,14315361,13299551,2351649051,
    2130989051,637872,331952011,2351649051,3589137051]    
    #searchIdx = 465610
    #searchIdx = 3210991

    search_indexs.each do |search_index|

      p 'browse_nodes ' + search_index.to_s
      #商品ID(ASIN)を取得
      asins = get_asins(search_index)
      
      #商品情報をセット
      setAmazonItemData(asins,search_index,"origin")
    end  
  end

  #過去のTop10商品の最新情報をセットする  
  task :dataset_now => :environment do
    #過去の商品ID(ASIN)を取得
    asins = get_asins_ago(3)
    
    #p asins
    
    #商品情報をセット
    asins10 = []
    idx = 1
    
    asins.each do |asin| 
      if (idx <= 10)
        asins10.push(asin)
        idx += 1
        if (idx > 10)
          setAmazonItemData(asins10,"","latest")
        #p "idx" + idx.to_s + ":" + asins10.to_s
          asins10 = []
          idx = 1
        end  
      end
    end
  end

  private

#  def selectBargainItem(asins)
#    asins.each to || do
#      if 
#      end  
#    end  
#  end

  def get_asins_ago(months)
    #itemsから何ヶ月前の商品データを取得し、asinの配列を返す
    _items = Item.find_by_sql(
      ["select asin,created_at from items where created_at >= current_timestamp + '-? months'", months])
    
    asins = []
    
    if _items 
      _items.each do |_item|
        
        asins.push(_item.asin)
      
      end
    end
    
    return asins
  end

  def setAmazonItemData(asins,search_index,dest)

    begin
      #商品情報を取得 最大10アイテムまで
      res = Amazon::Ecs.item_lookup(
                                asins.join(','),#'B00CHIL9JO', 
                                {
                                  :ResponseGroup => 'Large,Offers,VariationSummary', 
                                  :Condition => 'All',
                                  :country => 'jp'
                                }
                                )
  
  
    rescue Amazon::RequestError => e
      puts e.message
      #return render :js => "alert('#{e.message}')"
    end
# p res.marshal_dump
    begin

      res.items.each do |amazon_item|
          #p amazon_item.to_s
        #if (exits_item?(amazon_item.get('ASIN')))
        if (dest == "origin") 
          item = Item.new
        else  
          item = LatestItem.new
        end
        item.asin         = amazon_item.get('ASIN')
        item.title     = CGI.unescapeHTML(amazon_item.get('ItemAttributes/Title'))
        item.small_image  = amazon_item.get("SmallImage/URL")
        item.medium_image = amazon_item.get("MediumImage/URL")
        item.large_image  = amazon_item.get("LargeImage/URL")
        item.ofr_amount  = amazon_item.get("Offers/Offer/OfferListing/Price/Amount")
        item.val_amount  = amazon_item.get("VariationSummary/LowestPrice/Amount")
        item.sales_rank  = amazon_item.get("SalesRank")
        item.condition = amazon_item.get("Offers/Offer/OfferAttributes/Condition")
        item.availability  = amazon_item.get("Offers/Offer/OfferListing/Availability")
        item.detail_page_url = amazon_item.get("DetailPageURL")
        item.release_date = amazon_item.get("ItemAttributes/ReleaseDate")
        item.all_offers_url = amazon_item.get("Offers/MoreOffersUrl")
        item.search_index = search_index
        item.browse_node = amazon_item.get("BrowseNodes/BrowseNode/BrowseNodeId")
        item.browse_nodename = amazon_item.get("BrowseNodes/BrowseNode/Name")
        
        puts item.asin
        puts item.title  
        puts item.small_image
        puts item.medium_image
        puts item.large_image
        puts item.ofr_amount
        puts item.val_amount
        puts item.sales_rank
        puts item.condition
        puts item.availability
        puts item.detail_page_url
        puts item.release_date
        puts item.all_offers_url
        puts item.search_index
        puts item.browse_node
        puts item.browse_nodename
  
        item.save
      end
      
    rescue => e
      puts e.message
    end
    
    sleep(1) #アマゾンのAPI制限対応

  end    

  #SeachIndexごとにTOP10ランキングの商品(ASIN)を取得
  def get_asins(search_index)
    
    begin
      res = Amazon::Ecs.browse_node_lookup(
                                search_index,
                                {
                                  :response_group => 'TopSellers' ,
                                  :country => 'jp'
                                    
                                }
                                )
  
    rescue Amazon::RequestError => e
      puts e.message
      #return render :js => "alert('#{e.message}')"
    end
  
    begin
      asins = []
  
      res.get_elements('//TopItem').each do |amazon_item|
        asins.push(amazon_item.get('ASIN'))
      end
    rescue => e
      puts e.message    
    end
  
    sleep(1) #アマゾンのAPI制限対応

    #ASINの配列を返す
    return asins
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
