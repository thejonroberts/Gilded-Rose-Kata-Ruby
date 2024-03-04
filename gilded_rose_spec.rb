require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  let(:days) { 0..29 }
  let(:debug) { true }

  describe '#update_quality' do
    # use the patterns from texttest expectations (without installing TextTest)
    shared_examples_for 'known pattern' do |thing|
      let(:name) { thing[:name] }
      let(:sell_in_by_day) { thing[:sell_in_by_day] }
      let(:quality_by_day) { thing[:quality_by_day] }

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

    context 'with vest' do
      it_behaves_like 'known pattern', {
        name: '+5 Dexterity Vest',
        sell_in_by_day: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10,
                         -11, -12, -13, -14, -15, -16, -17, -18, -19, -20],
        quality_by_day: [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    end

    context 'with aged brie' do
      it_behaves_like 'known pattern', {
        name: 'Aged Brie',
        sell_in_by_day: [2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, -24, -25, -26, -27, -28],
        quality_by_day: [0, 1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38,
                         40, 42, 44, 46, 48, 50, 50, 50, 50, 50]
      }
    end

    context 'with Elixir of the Mongoose' do
      it_behaves_like 'known pattern', {
        name: 'Elixir of the Mongoose',
        sell_in_by_day: [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, -24, -25],
        quality_by_day: [7, 6, 5, 4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                         0, 0, 0, 0, 0, 0]
      }
    end

    context 'with Sulfuras, Hand of Ragnaros' do
      it_behaves_like 'known pattern', {
        name: 'Sulfuras, Hand of Ragnaros',
        sell_in_by_day: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        quality_by_day: [80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80,
                         80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80]
      }

      it_behaves_like 'known pattern', {
        name: 'Sulfuras, Hand of Ragnaros',
        sell_in_by_day: [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
        quality_by_day: [80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80,
                         80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80]
      }
    end

    context 'with Backstage passes to a TAFKAL80ETC concert' do
      it_behaves_like 'known pattern', {
        name: 'Backstage passes to a TAFKAL80ETC concert',
        sell_in_by_day: [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15],
        quality_by_day: [20, 21, 22, 23, 24, 25, 27, 29, 31, 33, 35, 38, 41, 44, 47, 50, 0, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }

      it_behaves_like 'known pattern', {
        name: 'Backstage passes to a TAFKAL80ETC concert',
        sell_in_by_day: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19, -20],
        quality_by_day: [49, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }

      it_behaves_like 'known pattern', {
        name: 'Backstage passes to a TAFKAL80ETC concert',
        sell_in_by_day: [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, -24, -25],
        quality_by_day: [49, 50, 50, 50, 50, 50, 0, 0, 0, 0, 0, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    end

    # TODO: not implemented
    xcontext 'Conjured Mana Cake' do
      it_behaves_like 'known pattern', {
        name: 'Conjured Mana Cake',
        sell_in_by_day: [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, -24, -25],
        quality_by_day: [49, 50, 50, 50, 50, 50, 0, 0, 0, 0, 0, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      }
    end
  end
end
