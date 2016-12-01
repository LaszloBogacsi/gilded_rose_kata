class GildedRose
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item.sell_in -= 1 if !legendary_item?(item)
      apply_rules_for(item) if normal_item?(item)
      apply_rules_for(item) if special_item?(item)
      apply_rules_for(item) if stage_pass?(item)
      apply_rules_for(item) if conjured_item?(item)
    end
  end

### ===> ITEM SELECTORS <=== ###
  def normal_item? item
    !special_item?(item) && !stage_pass?(item) && !conjured_item?(item) && !legendary_item?(item) ? true : false
  end

  def special_item? item
    ["Aged Brie"].include? item.name
  end

  def stage_pass? item
    ["Backstage passes to a TAFKAL80ETC concert"].include? item.name
  end

  def legendary_item? item
    ["Sulfuras, Hand of Ragnaros"].include? item.name
  end

  def conjured_item? item
    ["Conjured Mana Cake"].include? item.name
  end

### ===> RULES MANAGER <=== ###
  def apply_rules_for item
    case true
    when stage_pass?(item)
      stage_pass_rules(item)
    when normal_item?(item)
      normal_item_rules(item)
    when special_item?(item)
      special_item_rules(item)
    when conjured_item?(item)
      conjured_item_rules(item)
    end
  end

### ===> RULES <=== ###
  def normal_item_rules item
    item.quality -= 1 if item.quality > MIN_QUALITY
    item.quality -= 1 if item.sell_in < 0 && item.quality > MIN_QUALITY
  end

  def not_normal_item_rules item
    item.quality += 1
  end

  def special_item_rules item
    item.quality += 1 if item.quality < MAX_QUALITY
    item.quality += 1 if item.sell_in < 0 && item.quality < MAX_QUALITY
  end

  def stage_pass_rules item
    item.quality += 1 if item.sell_in > 11 && item.quality < MAX_QUALITY
    item.quality = 0 if item.sell_in < 0
    item.quality += 3 if (0..6).include?(item.sell_in) && item.quality < MAX_QUALITY
    item.quality += 2 if (6..11).include?(item.sell_in) && item.quality < MAX_QUALITY
  end

  def conjured_item_rules item
    item.quality -= 2 if item.quality > MIN_QUALITY
    item.quality -= 2 if item.sell_in < 0 && item.quality > MIN_QUALITY
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
