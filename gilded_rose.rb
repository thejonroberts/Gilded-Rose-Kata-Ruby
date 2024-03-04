class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items = @items.map do |item|
      this_item = case item.name
                  when 'Sulfuras, Hand of Ragnaros'
                    CollectorsItem.new(item.name, item.sell_in, item.quality)
                  when 'Aged Brie'
                    AgedItem.new(item.name, item.sell_in, item.quality)
                  when 'Backstage passes to a TAFKAL80ETC concert'
                    BackstagePass.new(item.name, item.sell_in, item.quality)
                  else
                    DepreciatingItem.new(item.name, item.sell_in, item.quality)
                  end
      this_item.update_quality
      this_item
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

  def update_quality; end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class CollectorsItem < Item
  def update_quality; end
end

class DepreciatingItem < Item
  def update_quality
    @sell_in -= 1
    @quality -= 1 if @quality > 0
    @quality -= 1 if @sell_in < 0 && @quality > 0
  end
end

class AgedItem < Item
  def update_quality
    @sell_in -= 1
    @quality += 1 if @quality < 50
    @quality += 1 if @sell_in < 0 && @quality < 50
  end
end

class BackstagePass < Item
  def update_quality
    @sell_in -= 1
    @quality += 1
    @quality += 1 if @sell_in < 10
    @quality += 1 if @sell_in < 5
    @quality = 50 if @quality > 50
    @quality = 0 if @sell_in < 0
  end
end
