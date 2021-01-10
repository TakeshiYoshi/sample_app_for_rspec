require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  describe 'ログイン前' do
    describe 'ユーザ新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザの新規作成が成功する' do
          visit sign_up_path
          expect {
            fill_in 'Email', with: 'example1@example.com'
            fill_in 'Password', with: 'foobar'
            fill_in 'Password confirmation', with: 'foobar'
            click_button 'SignUp'
          }.to change(User, :count).by(1)
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザの新規作成が失敗する' do
          visit sign_up_path
          expect {
            fill_in 'Email', with: ''
            fill_in 'Password', with: 'foobar'
            fill_in 'Password confirmation', with: 'foobar'
            click_button 'SignUp'
          }.not_to change{ User }
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザの新規作成が失敗する' do
          create(:user, email: 'example@example.com')
          visit sign_up_path
          expect {
            fill_in 'Email', with: 'example@example.com'
            fill_in 'Password', with: 'foobar'
            fill_in 'Password confirmation', with: 'foobar'
            click_button 'SignUp'
          }.not_to change{ User }
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスに失敗する' do
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as user }
    describe 'ユーザ編集' do
      let(:another_user) { create(:user) }
      context 'フォームの入力値が正常' do
        it 'ユーザの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: 'change@example.com'
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(user.reload.email).to eq 'change@example.com'
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: another_user.email
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content "Email has already been taken"
        end
      end
      context '他ユーザの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          create(:task, title: 'Test task', content: 'test content', status: :todo, user: user)
          visit user_path(user)
          expect(page).to have_content 'You have 1 task.'
          expect(page).to have_content 'Test task'
          expect(page).to have_content 'todo'
        end
      end
    end
  end
end
