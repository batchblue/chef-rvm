#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2010, 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# install rvm api gem during chef compile phase
Chef::Log.info("checking for Opsworks: #{OpsWorks} and internal gems: #{OpsWorks::InternalGems}")
if defined?(OpsWorks) && defined?(OpsWorks::InternalGems)
  Chef::Log.info("They're defined! chef internal rvm gem version: #{node['rvm']['chef_internal_rvm_gem_version']}")
  OpsWorks::InternalGems.internal_gem_package('rvm', :version => node['rvm']['chef_internal_rvm_gem_version'])
else
  chef_gem 'rvm' do
    action :install
    version '>= 1.11.3.6'
  end
end

ruby_block "require rvm" do
  block do
    require 'rvm'
    create_rvm_shell_chef_wrapper
    create_rvm_chef_user_environment
  end
  action :create
end

class Chef::Resource
  # mix in #rvm_cmd_wrap helper into resources
  include Chef::RVM::ShellHelpers
end

class Chef::Recipe
  # mix in recipe helpers
  include Chef::RVM::ShellHelpers
  include Chef::RVM::RecipeHelpers
  include Chef::RVM::StringHelpers
end
