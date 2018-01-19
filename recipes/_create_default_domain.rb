# Setup the Weblogic 12c domain.py file for silent creation of domain
template "#{node['centroid_weblogic']['tmp_dir']}/domain.py" do
  cookbook 'centroid_weblogic'
  source 'domain.py.erb'
  mode 0755
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  variables(domain_template_path: "#{node['centroid_weblogic']['middleware_home_dir']}/wlserver/common/templates/wls/wls.jar")
end

# Create the domain
execute 'Create Domain' do
  command "#{node['centroid_weblogic']['middleware_home_dir']}/oracle_common/common/bin/wlst.sh #{node['centroid_weblogic']['tmp_dir']}/domain.py"
  user node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  not_if { ::File.exist?("#{node['centroid_weblogic']['middleware_home_dir']}/user_projects/domains/default_domain/startWebLogic.sh") }
end

# Create security folder for boot.properties file
directory "#{node['centroid_weblogic']['middleware_home_dir']}/user_projects/domains/default_domain/servers/AdminServer/security" do
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  mode '0755'
  recursive true
  action :create
end

# Create boot.properties file to setup WebLogic Admin username and password
# Important! WebLogic changes this file after the domain starts, do not overwrite if it exists
template "#{node['centroid_weblogic']['middleware_home_dir']}/user_projects/domains/default_domain/servers/AdminServer/security/boot.properties" do
  cookbook 'centroid_weblogic'
  source 'boot.properties.erb'
  mode 0755
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  action :create_if_missing
end

# Start WebLogic Domain
bash 'Start WebLogic Domain' do
  cwd "#{node['centroid_weblogic']['middleware_home_dir']}/user_projects/domains/default_domain/"
  code <<-EOH
    nohup ./startWebLogic.sh > weblogic.out &
    EOH
  not_if 'ps -ef | grep startWebLogic.sh | grep default_domain'
  guard_interpreter :bash
end
