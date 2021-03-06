#
# Cookbook:: centroid_weblogic
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'centroid_weblogic::default' do
  let(:chef_run) do
    # for a complete list of available platforms and versions see:
    # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
    runner = ChefSpec::ServerRunner.new(platform: 'oracle', version: '7.4')
    runner.converge(described_recipe)
  end

  # context 'WebLogic default_domain is running' do
  #   it 'Skips Command' do
  #     stub_command('ps -ef | grep startWebLogic.sh | grep default_domain').and_return(0)
  #
  #     expect { chef_run }.to run_bash("Start WebLogic Domain")
  #   end
  # end
  #
  # context 'WebLogic default_domain is NOT running' do
  #   it 'Runs Command' do
  #     stub_command('ps -ef | grep startWebLogic.sh | grep default_domain').and_return(1)
  #
  #     expect { chef_run }.not_to run_bash("Start WebLogic Domain")
  #   end
  # end

  # it 'converges successfully' do
  #   chef_run # expect { chef_run }.to_not raise_error
  # end
end
