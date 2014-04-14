require 'spec_helper'

describe SearchContent do
  let(:search_content) { FactoryGirl.build(:search_content) }

  describe '#origin_title' do
    context 'when origin_title is not present' do
      before { search_content.origin_title = nil }
      it {
        expect(search_content).not_to be_valid
        expect(search_content).to have(1).error_on(:origin_title)
      }
    end
  end

  describe '#origin_content' do
    context 'when origin_content is not present' do
      before { search_content.origin_content = nil }
      it {
        expect(search_content).not_to be_valid
        expect(search_content).to have(1).error_on(:origin_content)
      }
    end
  end

  describe '.search' do
    let!(:search_content1) { FactoryGirl.create(:search_content, origin_title: '豚肉と白菜の炒めもの', origin_content: "人参\n豚肉\n白菜") }
    let!(:search_content2) { FactoryGirl.create(:search_content, origin_title: 'ハクサイの炒めもの', origin_content: "にんじん\n豚肉\n白菜") }
    let!(:search_content3) { FactoryGirl.create(:search_content, origin_title: '炒めもの', origin_content: "ニンジン\n豚肉\n白菜") }
    let!(:search_content4) { FactoryGirl.create(:search_content, origin_title: '麩の吸いもの', origin_content: "麩") }
    let!(:search_content5) { FactoryGirl.create(:search_content, origin_title: '麩の卵とじ', origin_content: "麩\n卵") }

    before(:all) do
      DatabaseCleaner.strategy = :truncation
    end

    after(:all) do
      DatabaseCleaner.strategy = :transaction
    end

    it 'ひらがなで検索してもカタカナと漢字がヒットする' do
      expect(SearchContent.search('にんじん')).to have(3).items
      expect(SearchContent.search('はくさい')).to have(3).items
    end

    it 'カタカナで検索してもひらがなと漢字がヒットする' do
      expect(SearchContent.search('ニンジン')).to have(3).items
      expect(SearchContent.search('ハクサイ')).to have(3).items
    end

    it '漢字で検索してもひらがなとカカタナカがヒットする' do
      expect(SearchContent.search('人参')).to have(3).items
      expect(SearchContent.search('白菜')).to have(3).items
    end

    it '検索結果が読みがな順になる' do
      expect(SearchContent.search('白菜').first).to eq search_content3
    end

    it 'レシピ名のあいまい検索出来る' do
      expect(SearchContent.search('白菜の')).to have(1).item
      expect(SearchContent.search('の炒めもの')).to have(2).item
    end

    it 'スペースで区切って複数ワードで検索出来る' do
      expect(SearchContent.search('ハクサイ 炒めもの')).to have(1).item
      expect(SearchContent.search('ハクサイ　炒めもの')).to have(1).item
      expect(SearchContent.search('豚肉 納豆')).to be_empty
    end

    it '複数ワードのレシピ名検索ができる' do
      expect(SearchContent.search('豚肉と 炒めもの')).to have(1).item
      expect(SearchContent.search('豚肉と うま煮')).to be_empty
    end

    it '検索ワード1文字でも検索出来る' do
      expect(SearchContent.search('ニ')).to have(2).item
      expect(SearchContent.search('に')).to have(2).item
      expect(SearchContent.search('人')).to have(1).item
      expect(SearchContent.search('豚 炒')).to have(1).item
      expect(SearchContent.search('麩 吸いもの')).to have(1).item
    end
  end

  describe 'analyze_title_and_content' do
    let!(:search_content) { FactoryGirl.create(:search_content, origin_title: '大根', origin_content: '人参') }
    it {
      expect(search_content.title).to eq '大根 ダイコン'
      expect(search_content.content).to eq '人参 ニンジン'
      expect(search_content.title_yomi).to eq 'ダイコン'
    }
  end
end
