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

class NormalItem < Item
  def end_of_day_update
    update_sell_in
    update_quality
    limit_quality
  end

  def update_sell_in
    @sell_in -= 1
  end

  def update_quality
    @quality -= 1
    @quality -= 1 if @sell_in.negative?
  end

  def limit_quality
    @quality = 0 if @quality.negative?
    @quality = 50 if @quality > 50
  end
end

class AgedItem < NormalItem
  def update_quality
    @quality += 1
    @quality += 1 if @sell_in.negative?
  end
end

class BackstagePass < NormalItem
  def update_quality
    @quality += 1
    @quality += 1 if @sell_in < 10
    @quality += 1 if @sell_in < 5
    @quality = 0 if @sell_in.negative?
  end
end

class ConjuredItem < NormalItem
  def update_quality
    @quality -= 2
    @quality -= 2 if @sell_in.negative?
  end
end

class LegendaryItem < NormalItem
  def update_sell_in; end
  def update_quality; end
  def limit_quality; end
end

class GildedRose
  DEFAULT_ITEM_CLASS = NormalItem
  SPECIAL_ITEM_CLASSES = {
    'Sulfuras, Hand of Ragnaros' => LegendaryItem,
    'Aged Brie' => AgedItem,
    'Conjured Mana Cake' => ConjuredItem,
    'Backstage passes to a TAFKAL80ETC concert' => BackstagePass
  }.freeze

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.map do |item|
      klass = SPECIAL_ITEM_CLASSES[item.name] || DEFAULT_ITEM_CLASS
      klass.new(item.name, item.sell_in, item.quality)
           .tap(&:end_of_day_update)
    end
  end
end
