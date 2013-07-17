data_users = data_bag('users')
data_users.each do |id|
  u = data_bag_item('users', id)
  user u['id'] do
    shell    u['shell']
    password u['password']
    supports :manage_home => true, :non_unique => false
    action   [:create]
  end
end

group 'wheel' do
  group_name 'wheel'
  members    ['hoge']
end
