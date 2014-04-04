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

  context 'search method' do
    let!(:search_content1) { FactoryGirl.create(:search_content, origin_title: '白菜の炒めもの', origin_content: "人参\n豚肉\n白菜") }
    let!(:search_content2) { FactoryGirl.create(:search_content, origin_title: 'ハクサイの炒めもの', origin_content: "にんじん\n豚肉\n白菜") }
    let!(:search_content3) { FactoryGirl.create(:search_content, origin_title: '炒めもの', origin_content: "ニンジン\n豚肉\n白菜") }

    before(:all) do
      DatabaseCleaner.strategy = :truncation
    end

    after(:all) do
      DatabaseCleaner.strategy = :transaction
    end

    describe '.fulltext_search' do

      it {
        expect(SearchContent.fulltext_search('にんじん')).to have(3).item
        expect(SearchContent.fulltext_search('ニンジン')).to have(3).item
        expect(SearchContent.fulltext_search('人参')).to have(3).item
        expect(SearchContent.fulltext_search('白菜')).to have(3).item
        expect(SearchContent.fulltext_search('ハクサイ')).to have(3).item
        expect(SearchContent.fulltext_search('はくさい')).to have(3).item
      }
    end

    describe '.ngram_search' do
      it {
        expect(SearchContent.ngram_search('白菜の')).to have(1).item
        expect(SearchContent.ngram_search('炒めもの')).to have(3).item
        expect(SearchContent.ngram_search('人参')).to have(1).item
        expect(SearchContent.ngram_search('にんじん')).to have(2).item
        expect(SearchContent.ngram_search('ニンジン')).to have(2).item
        expect(SearchContent.ngram_search('白菜')).to have(3).item
        expect(SearchContent.ngram_search('ハクサイ')).to have(1).item
        expect(SearchContent.ngram_search('はくさい')).to have(1).item
      }
    end

    describe '.search' do
      it {
        expect(SearchContent.search('にんじん')).to have(3).item
        expect(SearchContent.search('ニンジン')).to have(3).item
        expect(SearchContent.search('人参')).to have(3).item
        expect(SearchContent.search('はくさい')).to have(3).item
        expect(SearchContent.search('ハクサイ')).to have(3).item
        expect(SearchContent.search('白菜')).to have(3).item
      }
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
