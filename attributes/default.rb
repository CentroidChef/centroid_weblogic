default['centroid_weblogic']['create_default_domain'] = true

default['centroid_weblogic']['java_source_url'] = 'http://chef-assets.centroid.com/software/java'
default['centroid_weblogic']['java_source_filename'] = 'jdk-8u151-linux-x64.tar.gz'
default['centroid_weblogic']['java_dir_name'] = 'jdk1.8.0_151'
default['centroid_weblogic']['java_home'] = '' # Set by _install_java

default['centroid_weblogic']['wls_source_url'] = 'http://chef-assets.centroid.com/software/weblogic'
default['centroid_weblogic']['wls_source_filename'] = 'fmw_12.2.1.3.0_wls.jar'
default['centroid_weblogic']['middleware_home_dir'] = '/home/oracle/middleware'
default['centroid_weblogic']['os_user'] = 'oracle'
default['centroid_weblogic']['os_user_home_dir'] = '/home'
default['centroid_weblogic']['os_shell'] = '/bin/bash'
default['centroid_weblogic']['os_group'] = 'oinstall'
default['centroid_weblogic']['ora_inventory_dir'] = '/home/oracle/oraInventory'
default['centroid_weblogic']['tmp_dir'] = '/tmp'
default['centroid_weblogic']['install_type'] = 'WebLogic Server'
