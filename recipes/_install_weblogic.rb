# create /stage folder for any installation files
directory '/stage' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

# get weblogic software from repository
remote_file "/stage/#{node['centroid_weblogic']['wls_source_filename']}" do
  source "#{node['centroid_weblogic']['wls_source_url']}/#{node['centroid_weblogic']['wls_source_filename']}"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# create the oracle inventory location under the WebLogic OS user
directory node['centroid_weblogic']['ora_inventory_dir'] do
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  mode 0775
  recursive true
  action :create
end

# Add oraInst.loc to the oracle inventory location
template "#{node['centroid_weblogic']['ora_inventory_dir']}/oraInst.loc" do
  cookbook 'centroid_weblogic'
  source 'oraInst.loc.erb'
  mode 0755
  variables(ora_inventory_dir: node['centroid_weblogic']['ora_inventory_dir'],
            os_group: node['centroid_weblogic']['os_group'])
  action :create
end

# create the middleware home directory
directory node['centroid_weblogic']['middleware_home_dir'] do
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  mode 0775
  recursive true
  action :create
end

# Setup the Weblogic 12c response file for the silent install
template "#{node['centroid_weblogic']['tmp_dir']}/wls_12c.rsp" do
  cookbook 'centroid_weblogic'
  source 'wls_12c.rsp.erb'
  mode 0755
  owner node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  variables(middleware_home_dir: node['centroid_weblogic']['middleware_home_dir'],
            install_type: node['centroid_weblogic']['install_type'])
end

# Run the installation
execute 'Install WLS' do
  command "#{node['centroid_weblogic']['java_home']}/bin/java -Xmx1024m -Djava.io.tmpdir=#{node['centroid_weblogic']['tmp_dir']} -jar /stage/#{node['centroid_weblogic']['wls_source_filename']} -silent -responseFile #{node['centroid_weblogic']['tmp_dir']}/wls_12c.rsp -invPtrLoc #{node['centroid_weblogic']['ora_inventory_dir']}/oraInst.loc"
  user node['centroid_weblogic']['os_user']
  group node['centroid_weblogic']['os_group']
  cwd node['centroid_weblogic']['tmp_dir']
  not_if { ::File.exist?("#{node['centroid_weblogic']['middleware_home_dir']}/wlserver/common/bin/wlst.sh") }
end
