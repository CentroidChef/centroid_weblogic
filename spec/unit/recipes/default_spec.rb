#
# Cookbook:: centroid_weblogic
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'centroid_weblogic::default' do

  context 'When WebLogic is running' do
    stub_command("ps -ef | grep startWebLogic.sh | grep default_domain").and_return(1)
  end

  context 'When WebLogic is NOT running' do
    stub_command("ps -ef | grep startWebLogic.sh | grep default_domain").and_return(0)
  end
  
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
