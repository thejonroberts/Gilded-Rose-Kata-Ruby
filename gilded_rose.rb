class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items = @items.map do |item|
      if item.name == 'Sulfuras, Hand of Ragnaros'
        return no_update item
      end

      if item.name == 'Aged Brie'
        return brie_update item
      end

      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        return backstage_pass_update item
      end

      normal_update item
    end
  end

  def no_update(item)
    item
  end

  def normal_update(item)
    item.sell_in -= 1
    item.quality -= 1 if item.quality > 0
    item.quality -= 1 if item.sell_in < 0 && item.quality > 0
    item
  end

  def brie_update(item)
    item.sell_in -= 1
    item.quality += 1 if item.quality < 50
    item.quality += 1 if item.sell_in < 0 && item.quality < 50
    item
  end

  def backstage_pass_update(item)
    item.sell_in -= 1
    item.quality += 1
    item.quality += 1 if item.sell_in < 10
    item.quality += 1 if item.sell_in < 5
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.sell_in < 0
    item
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def limit_quality; end
  def update_quality; end
  def update_sell_in; end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class CollectorsItem
  attr_accessor :name, :sell_in, :quality

  def limit_quality; end
  def update_quality; end
  def update_sell_in; end
end
