#
# Cookbook:: centroid_weblogic
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Configures SELinux and Firewalld for WebLogic.
include_recipe 'centroid_weblogic::_config_security'

# Configures users and groups for WebLogic.
include_recipe 'centroid_weblogic::_config_users_groups'

# Install Java
include_recipe 'centroid_weblogic::_install_java'

# Install Weblogic
include_recipe 'centroid_weblogic::_install_weblogic'

# Configure a Default WebLogic Domain (optional)
if node['centroid_weblogic']['create_default_domain'] == true
  include_recipe 'centroid_weblogic::_create_default_domain'
end
