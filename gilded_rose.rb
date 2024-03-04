class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name == 'Sulfuras, Hand of Ragnaros'

      if item.name == '+5 Dexterity Vest' || item.name == 'Elixir of the Mongoose'
        item.sell_in -= 1
        item.quality -= 1 if item.quality > 0
        item.quality -= 1 if item.sell_in < 0 && item.quality > 0
      end
      if item.name == 'Aged Brie'
        item.sell_in -= 1
        item.quality += 1 if item.quality < 50
        item.quality += 1 if item.sell_in < 0 && item.quality < 50
      end
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        item.sell_in -= 1
        item.quality += 1
        item.quality += 1 if item.sell_in < 10
        item.quality += 1 if item.sell_in < 5
        item.quality = 50 if item.quality > 50
        item.quality = 0 if item.sell_in < 0
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

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
