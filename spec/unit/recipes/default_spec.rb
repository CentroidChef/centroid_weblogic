#
# Cookbook:: centroid_weblogic
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'centroid_weblogic::default' do

  context 'When all attributes are default, on an Oracle 7 platform' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'oracle', version: '7.4')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # expect { chef_run }.to_not raise_error
    end
  end
end
