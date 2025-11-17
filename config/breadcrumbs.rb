crumb :root do
  link "トップページ", root_path
end

crumb :facility do |facility|
  link facility.title, facility_path(facility)
  parent :root
end

crumb :facility_edit do |facility|
  link "投稿編集"
  parent :facility, facility
end

crumb :facility_new do
  link "新規投稿"
  parent :root
end

crumb :users do |user|
  link "マイページ", user_path(user)
  parent :root
end

crumb :users_edit do |user|
  link "プロフィール編集", edit_user_registration_path
  parent :users, user
end


# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
