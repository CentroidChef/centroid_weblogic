#
# Cookbook:: centroid_weblogic
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# create the necessary groups and users
group 'oinstall' do
  gid '1002'
  action :create
end

user 'oracle' do
  gid 'oinstall'
  password 'ZAQ!@WSX'
  action :create
end

# create /stage folder for any installation files
directory '/stage' do
  owner 'oracle'
  group 'oinstall'
  mode '0755'
  recursive true
  action :create
end

# get weblogic software from repository
remote_file '/stage/fmw_12.2.1.3.0_wls.jar' do
  source 'http://chef-assets.centroid.com/software/weblogic/fmw_12.2.1.3.0_wls.jar'
  owner 'oracle'
  group 'oinstall'
  mode '0755'
  action :create
end

# get java software from repository
remote_file '/stage/jdk-8u151-linux-x64.tar.gz' do
  source 'http://chef-assets.centroid.com/software/java/jdk-8u151-linux-x64.tar.gz'
  owner 'oracle'
  group 'oinstall'
  mode '0755'
  action :create
end

# create java directory
directory '/java' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# Unpack the JDK into the /java directory
execute 'Unpack JDK' do
  command "tar xzvf /stage/jdk-8u151-linux-x64.tar.gz --directory /java"
end

# Set this java version into the list of alternatives (it will be the default version on a clean system)
%w( java javac javaws keytool ).each do |file|
  execute "alternatives #{file}" do
    command "alternatives --install /usr/bin/#{file} #{file} /java/jdk1.8.0_151/bin/#{file} 1"
  end
end

# Set correct user and owner of /java directories
execute 'chown java_home' do
  command "chown -R root:root /java"
end

# add oraInst.loc to /etc for the oracle inventory location
# template "#{params[:orainst_dir]}/oraInst.loc" do
#   cookbook 'fmw_wls'
#   source 'oraInst.loc'
#   mode 0755
#   variables(ora_inventory_dir: params[:ora_inventory_dir],
#             os_group:          params[:os_group])
#   action :create
# end
#
# # create the oracle inventory location under the WebLogic OS user
# directory params[:ora_inventory_dir] do
#   owner params[:os_user]
#   group params[:os_group]
#   mode 0775
#   action :create
# end
