# frozen_string_literal: true

require 'spec_helper'


describe 'role::example' do
  os_set = {
    hardwaremodels: ['x86_64'],
    supported_os: [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['9'],
      },
    ],
  }
  on_supported_os(os_set).each do |os, os_facts|
    context "on #{os}" do

      let(:facts) { os_facts } 

      it { is_expected.to contain_class('profile::example') }
      it { is_expected.to contain_notify('grafana_port is 443') }
      it { is_expected.to compile.with_all_deps }
    end
  end
end
