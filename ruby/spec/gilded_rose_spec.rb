require File.join(File.dirname(__FILE__), '../lib/gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    context 'normal items, main rules' do

      let(:items) {[Item.new("foo", 10, 10)]}

      it "does not change the name" do
        GildedRose.new(items).update_quality
        expect(items[0].name).to eq "foo"
      end

      it 'lowers the sell_in for an item after a day' do
        expect { GildedRose.new(items).update_quality }.to change {items[0].sell_in}.from(10).to(9)
      end

      it 'lowers the quality for an item after a day' do
        expect { GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(9)
      end

      context 'normal items, special rules' do

        let(:items) {[Item.new("foo", 0, 3)]}
        it "lowers the quality twice as fast, once the sell by date has passed" do
          expect { GildedRose.new(items).update_quality }.to change {items[0].quality}.from(3).to(1)
        end

        it "items quality never goes negative" do
          gilded_rose = GildedRose.new(items)
          expect { 3.times{gilded_rose.update_quality} }.to change {items[0].quality}.from(3).to(0)
        end

      end
      context "Special items, special rules" do
        context "Aged Brie" do
          let(:items) {[Item.new("Aged Brie", 10, 10)]}
          it "increases it's quality as time passes" do
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(11)
          end

          it "items quality is never more than 50" do
            expect { 50.times{GildedRose.new(items).update_quality} }.to change {items[0].quality}.from(10).to(50)
          end
        end
        context "Sulfuras" do
          let(:items) {[Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]}
          it "never has to be sold" do
            expect{ GildedRose.new(items).update_quality }.to_not change {items[0].sell_in}
          end
          it "never decreases in quality" do
            expect{ GildedRose.new(items).update_quality }.to_not change {items[0].quality}
          end
          it "has a constant quality of 80" do
            GildedRose.new(items).update_quality
            expect(items[0].quality).to eq 80
          end

        end

        context "Backstage passes" do
          it "increases quality by 1 as sell_in value more than 10" do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(11)

          end
          it "increases quality by 2 as sell_in value is 10 or less" do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(12)

          end
          it "increases quality by 3 as sell_in value is equal or less than 5" do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(13)

          end
          it "quality drops to 0 after concert" do
            items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(0)

          end

        end
        context "conjured items" do
          it "degrages in quality twice as fast as normal items" do
            items = [Item.new("Conjured Mana Cake", 10, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(8)
          end
          it "degrages in quality twice as fast as normal items when sell date has passed" do
            items = [Item.new("Conjured Mana Cake", 0, 10)]
            expect{ GildedRose.new(items).update_quality }.to change {items[0].quality}.from(10).to(6)
          end
        end
      end

    end
  end
  describe 'categorizer' do
    let(:items) {[Item.new("normal item", 10, 10),
      Item.new("Aged Brie", 10, 10),
      Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
      Item.new("Conjured Mana Cake", 10, 10) ]}

      describe '#normal_item?' do

        it 'returns true if the item is normal (not special, legendary or conjured)' do
          expect(GildedRose.new(items).normal_item?(items[0])).to eq true
        end
        it 'returns false if the item is anything but normal' do
          expect(GildedRose.new(items).normal_item?(items[1])).to eq false
        end
      end
      describe '#special_item?' do
        it "returns true if the item is special_item" do
          expect(GildedRose.new(items).special_item?(items[1])).to eq true
        end
        it "returns false if the item anything but special_item" do
          expect(GildedRose.new(items).special_item?(items[2])).to eq false
        end
      end
      describe '#legendary_item?' do
        it "returns true if the item is legendary_item" do
          expect(GildedRose.new(items).legendary_item?(items[2])).to eq true
        end
        it "returns false if the item anything but legendary_item" do
          expect(GildedRose.new(items).legendary_item?(items[3])).to eq false
        end
      end
      describe '#conjured_item?' do
        it "returns true if the item is conjured_item" do
          expect(GildedRose.new(items).conjured_item?(items[3])).to eq true
        end
        it "returns false if the item anything but conjured_item" do
          expect(GildedRose.new(items).conjured_item?(items[0])).to eq false
        end
      end
    end

  end
