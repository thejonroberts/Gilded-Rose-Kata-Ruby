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
    end

    context 'with aged items' do
      it_behaves_like 'known pattern',
                      'Aged Brie',
                      [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19,
                       -20, -21, -22, -23, -24, -25, -26, -27, -28],
                      [0, 1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46,
                       48, 50, 50, 50, 50, 50]
    end

    context 'with collectable Item' do
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
      it_behaves_like 'known pattern',
                      'Conjured Mana Cake',
                      [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17,
                       -18, -19, -20, -21, -22, -23, -24, -25],
                      [49, 50, 50, 50, 50, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       0]
    end
  end
end
