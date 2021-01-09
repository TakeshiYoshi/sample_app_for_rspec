require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    it 'すべての要素が正しければ有効な状態であること' do
      task = build(:task)
      expect(task.errors).to be_empty
    end

    it 'titleが無ければ無効な状態であること' do
      task = build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'titleが重複していれば無効な状態であること' do
      create(:task, title: 'Test task')
      task = build(:task, title: 'Test task')
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    it 'statusが無ければ無効な状態であること' do
      task = build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end
  end
end
