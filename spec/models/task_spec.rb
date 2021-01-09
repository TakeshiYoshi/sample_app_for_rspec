require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    it 'すべての要素が正しければ有効な状態であること' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'titleが無ければ無効な状態であること' do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'titleが重複していれば無効な状態であること' do
      create(:task, title: 'Test task')
      task_duplicated_title = build(:task, title: 'Test task')
      expect(task_duplicated_title).to be_invalid
      expect(task_duplicated_title.errors[:title]).to include('has already been taken')
    end

    it 'titleが重複していなければtaskが作成可能であること' do
      create(:task, title: 'Test task')
      task_another_title = build(:task, title: 'Another task')
      expect(task_another_title).to be_valid
      expect(task_another_title.errors).to be_empty
    end

    it 'statusが無ければ無効な状態であること' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end
  end
end
