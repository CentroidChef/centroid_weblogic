# Configure the group (i.e. oinstall)
group node['centroid_weblogic']['os_group'] do
  action :create
end

# Configure the user (i.e. oracle)
user node['centroid_weblogic']['os_user'] do
  comment 'Created by Chef for WebLogic installation'
  gid node['centroid_weblogic']['os_group']
  shell node['centroid_weblogic']['os_shell']
  home node['centroid_weblogic']['os_user_home_dir'] + '/' + node['centroid_weblogic']['os_user']
  manage_home true
  action :create
end
