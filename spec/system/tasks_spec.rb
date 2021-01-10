require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let(:another_task) { create(:task) }
  describe 'ログイン前' do
    describe 'タスクの新規作成' do
      context 'ログインしていない状態' do
        it 'アクセスに失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
    describe 'タスクの編集' do
      context 'ログインしていない状態' do
        it 'アクセスに失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as user }
    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          expect {
            fill_in 'Title', with: 'new task'
            fill_in 'Content', with: 'new content'
            select 'doing', from: 'Status'
            fill_in 'Deadline', with: DateTime.new(2021, 1, 1, 0, 0)
            click_button 'Create Task'
          }.to change(Task, :count).by(1)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'Title: new task'
          expect(page).to have_content 'Content: new content'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2021/1/1 0:0'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          expect {
            fill_in 'Title', with: ''
            fill_in 'Content', with: 'new content'
            select 'doing', from: 'Status'
            fill_in 'Deadline', with: DateTime.new(2021, 1, 1, 0, 0)
            click_button 'Create Task'
          }.not_to change{ Task }
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end
      context '登録済みのタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          expect {
            fill_in 'Title', with: task.title
            fill_in 'Content', with: 'new content'
            select 'doing', from: 'Status'
            fill_in 'Deadline', with: DateTime.new(2021, 1, 1, 0, 0)
            click_button 'Create Task'
          }.not_to change{ Task }
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'Changed title'
          fill_in 'Content', with: 'Changed content'
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Title: Changed title'
          expect(page).to have_content 'Content: Changed content'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end
      context '登録済みのタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: another_task.title
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end
    
    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }
      it 'タスクの削除に成功する' do
        visit tasks_path
        click_on 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
      end
    end
  end
end
