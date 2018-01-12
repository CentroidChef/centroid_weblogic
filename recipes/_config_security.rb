# Configure SELinux to "permissive"
execute 'setenforce' do
  command 'sudo setenforce permissive'
end

# Configure SELinux conf file for "permissive" (maintain setting after reboot)
template '/etc/selinux/config' do
  source 'selinux.erb'
end

# Add rule to firewall to accept http traffic
execute 'weblogic_firewall_http' do
  command 'firewall-cmd  --permanent --zone public --add-port 7001/tcp'
  ignore_failure true
end

# Add rule to firewall to accept http traffic
execute 'weblogic_firewall_https' do
  command 'firewall-cmd  --permanent --zone public --add-port 7002/tcp'
  ignore_failure true
end

# Reload firewall after adding rule
execute 'reload_firewall' do
  command 'firewall-cmd --reload'
  ignore_failure true
end
