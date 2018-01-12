node.default['centroid_weblogic']['java_home'] = "/java/#{node['centroid_weblogic']['java_dir_name']}"

# create /stage folder for any installation files
directory '/stage' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# get java software from repository
remote_file "/stage/#{node['centroid_weblogic']['java_source_filename']}" do
  source "#{node['centroid_weblogic']['java_source_url']}/#{node['centroid_weblogic']['java_source_filename']}"
  owner 'root'
  group 'root'
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
  command "tar xzvf /stage/#{node['centroid_weblogic']['java_source_filename']} --directory /java"
  not_if { ::File.exist?("#{node['centroid_weblogic']['java_home']}/bin/java") }
end

# Set this java version into the list of alternatives (it will be the default version on a clean system)
%w( java javac javaws keytool ).each do |file|
  execute "alternatives #{file}" do
    command "alternatives --install /usr/bin/#{file} #{file} #{node['centroid_weblogic']['java_home']}/bin/#{file} 1"
  end
end

# Set correct user and owner of /java directories
execute 'chown java_home' do
  command 'chown -R root:root /java'
end
