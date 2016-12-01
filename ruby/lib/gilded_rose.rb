class GildedRose
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  def initialize(items)
    @items = items
  end

  def normal_item? item
    !special_item?(item) && !conjured_item?(item) && !legendary_item?(item) ? true : false
  end

  def special_item? item
    ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"].include? item.name
  end

  def legendary_item? item
    ["Sulfuras, Hand of Ragnaros"].include? item.name
  end

  def conjured_item? item
    ["Conjured Mana Cake"].include? item.name
  end

  def update_quality()
    @items.each do |item|
      if normal_item?(item) && item.quality > MIN_QUALITY
        item.quality -= 1

      # if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
      #   if item.quality > 0
      #     if item.name != "Sulfuras, Hand of Ragnaros"
      #       item.quality = item.quality - 1
      #     end
      #   end
      else
        if item.quality < MAX_QUALITY
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
