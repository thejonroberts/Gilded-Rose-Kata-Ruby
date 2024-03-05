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
      it 'increases quality by 1 per day before sell date' do
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

    context 'with legendary item' do
      it 'does not change quality' do
        quality = 80
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, quality)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq quality
      end

      it 'does not change sell_in' do
        sell_in = 0
        item = Item.new('Sulfuras, Hand of Ragnaros', sell_in, 80)
        results = described_class.new([item]).update_quality
        expect(results[0].sell_in).to eq sell_in
      end

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
      it 'increases quality by 1 per day 11 or more days before sell date' do
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 11
      end

      it 'increases quality by 2 per day 6-10 days before sell date' do
        sell_in = [6, 7, 8, 9, 10].sample
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 12
      end

      it 'increases quality by 3 per day 1-5 days before sell date' do
        sell_in = [1, 2, 3, 4, 5].sample
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 13
      end

      it 'does not increase quality above fifty' do
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 49)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 50
      end

      it 'sets value to zero after sell date' do
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)
        results = described_class.new([item]).update_quality
        expect(results[0].quality).to eq 0
      end

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

    xcontext 'with conjured items' do
      # We have recently signed a supplier of conjured items. This requires an update to our system:
      # "Conjured" items degrade in Quality twice as fast as normal items
      # Once the sell by date has passed, Quality degrades twice as fast
    end
  end
end
