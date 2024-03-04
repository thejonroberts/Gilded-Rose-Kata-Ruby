class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

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
    @quality -= 1 if @sell_in < 0
  end

  def limit_quality
    @quality = 0 if @quality < 0
    @quality = 50 if @quality > 50
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class CollectorsItem < Item
  def update_sell_in; end
  def update_quality; end
  def limit_quality; end
end

class AgedItem < Item
  def update_quality
    @quality += 1
    @quality += 1 if @sell_in < 0
  end
end

class BackstagePass < Item
  def update_quality
    @quality += 1
    @quality += 1 if @sell_in < 10
    @quality += 1 if @sell_in < 5
    @quality = 0 if @sell_in < 0
  end
end

class GildedRose
  DEFAULT_CLASS = Item
  SPECIAL_CLASSES = {
    'Sulfuras, Hand of Ragnaros' => CollectorsItem,
    'Aged Brie' => AgedItem,
    'Backstage passes to a TAFKAL80ETC concert' => BackstagePass
  }.freeze

  def initialize(items)
    @items = items
  end

  def klass_for(name)
    SPECIAL_CLASSES[name] || DEFAULT_CLASS
  end

  def update_quality
    @items = @items.map do |item|
      this_item = klass_for(item.name).new(item.name, item.sell_in, item.quality)
      this_item.end_of_day_update
      this_item
    end
  end
end
