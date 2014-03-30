require 'spec_helper'

describe Recipe do
  let(:recipe) { FactoryGirl.build(:recipe) }

  describe 'title' do
    context 'when title is not present' do
      before { recipe.title = nil }
      it {
        expect(recipe).not_to be_valid
        expect(recipe).to have(1).error_on(:title)
      }
    end
  end

  describe 'content' do
    context 'when content is not present' do
      before { recipe.content = nil }
      it {
        expect(recipe).not_to be_valid
        expect(recipe).to have(1).error_on(:content)
      }
    end
  end

  describe 'update_search_content' do
    context 'when after create' do
      it { expect { recipe.save }.to change(SearchContent, :count).by(1) }
    end
    context 'when after update' do
      let(:old_title) { '旧タイトル' }
      let(:update_title) { '更新タイトル' }
      let(:recipe) { FactoryGirl.create(:recipe, title: old_title) }
      before { recipe.update(title: update_title) }
      it {
        expect(SearchContent.find_by(origin_title: old_title)).to be_nil
        expect(SearchContent.find_by(origin_title: update_title).origin_title).to eq update_title
      }
    end
  end

  describe 'remove_search_content' do
    before { recipe.save }
    it { expect { recipe.destroy }.to change(SearchContent, :count).by(-1) }
  end
end
