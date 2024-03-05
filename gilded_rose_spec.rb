require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  let(:days) { 0..29 }

  describe '#update_quality' do
    shared_examples_for 'known pattern' do |name, sell_in_by_day, quality_by_day|
      # use the patterns from texttest expectations (without installing TextTest)

      it 'sets sell_in' do
        days.each do |day|
          item = Item.new(name, sell_in_by_day[day], quality_by_day[day] || 0)
          results = described_class.new([item]).update_quality
          expect(results[0].sell_in).to eq(sell_in_by_day[day + 1])
        end
      end

      it 'sets quality' do
        days.each do |day|
          item = Item.new(name, sell_in_by_day[day], quality_by_day[day] || 0)
          results = described_class.new([item]).update_quality
          expect(results[0].quality).to eq quality_by_day[day + 1]
        end
      end
    end

    context 'with normal items' do
      # All items have a SellIn value which denotes the number of days we have to sell the items
      # All items have a Quality value which denotes how valuable the item is
      # At the end of each day our system lowers both values for every item
      # Pretty simple, right? Well this is where it gets interesting:

      # Once the sell by date has passed, Quality degrades twice as fast
      # The Quality of an item is never negative
      # The Quality of an item is never more than 50

      it 'reduces quality by 1 per day' do
        item = Item.new('foo', 10, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 9
      end

      it 'reduces quality by 2 per day after sell date' do
        item = Item.new('foo', 0, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 8
      end

      it 'does not reduce quality below zero' do
        item = Item.new('foo', 0, 0)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 0
      end

      it_behaves_like 'known pattern',
                      '+5 Dexterity Vest',
                      [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14,
                       -15, -16, -17, -18, -19, -20],
                      [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       0, 0, 0]

      it_behaves_like 'known pattern',
                      'Elixir of the Mongoose',
                      [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17,
                       -18, -19, -20, -21, -22, -23, -24, -25],
                      [7, 6, 5, 4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      it_behaves_like 'known pattern',
                      'Conjured Mana Cake',
                      [3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18,
                       -19, -20, -21, -22, -23, -24, -25, -26, -27],
                      [6, 5, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    end

    context 'with aged items' do
      # "Aged Brie" actually increases in Quality the older it gets

      it 'increases quality by 1 per day' do
        item = Item.new('Aged Brie', 10, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 11
      end

      it 'increases quality by 2 per day after sell date' do
        item = Item.new('Aged Brie', 0, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 12
      end

      it 'does not increase quality above fifty' do
        item = Item.new('Aged Brie', 0, 50)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 50
      end

      it_behaves_like 'known pattern',
                      'Aged Brie',
                      [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19,
                       -20, -21, -22, -23, -24, -25, -26, -27, -28],
                      [0, 1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46,
                       48, 50, 50, 50, 50, 50]
    end

    context 'with collectable Item' do
      # "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
      it_behaves_like 'known pattern',
                      'Sulfuras, Hand of Ragnaros',
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                      [80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80,
                       80, 80, 80, 80, 80, 80, 80]

      it_behaves_like 'known pattern',
                      'Sulfuras, Hand of Ragnaros',
                      [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                       -1, -1, -1, -1, -1, -1, -1],
                      [80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80,
                       80, 80, 80, 80, 80, 80, 80]
    end

    context 'with backstage passes' do
      # "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
      # Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
      # Quality drops to 0 after the concert

      it_behaves_like 'known pattern',
                      'Backstage passes to a TAFKAL80ETC concert',
                      [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10,
                       -11, -12, -13, -14, -15],
                      [20, 21, 22, 23, 24, 25, 27, 29, 31, 33, 35, 38, 41, 44, 47, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       0, 0, 0, 0]

      it_behaves_like 'known pattern',
                      'Backstage passes to a TAFKAL80ETC concert',
                      [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14,
                       -15, -16, -17, -18, -19, -20],
                      [49, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       0, 0, 0]

      it_behaves_like 'known pattern',
                      'Backstage passes to a TAFKAL80ETC concert',
                      [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17,
                       -18, -19, -20, -21, -22, -23, -24, -25],
                      [49, 50, 50, 50, 50, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       0]
    end

    context 'with conjured items' do
      # We have recently signed a supplier of conjured items. This requires an update to our system:
      # "Conjured" items degrade in Quality twice as fast as normal items
      # Once the sell by date has passed, Quality degrades twice as fast
    end
  end
end
