#
# Cookbook Name:: tfly-artifactory
# Recipe:: default
#
# Copyright (C) 2015 Ticketfly LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

docker_service 'default' do
  action [:create, :start]
end

docker_image "#{node['tfly-artifactory']['repo']}" do
  tag node['tfly-artifactory']['version']
  action :pull
  tls false
end

['data', 'logs', 'backup'].each do |directory_name|
  directory "#{node['tfly-artifactory']['home']}/#{directory_name}" do
    mode '777'
    recursive true
  end
end

docker_container 'artifactory' do
  repo node['tfly-artifactory']['repo']
  tag node['tfly-artifactory']['version']
  port '8081:8081'
  env [
    "ARTIFACTORY_HOME=#{node['tfly-artifactory']['home']}"
  ]
  volumes [
    "#{node['tfly-artifactory']['home']}/data:#{node['tfly-artifactory']['home']}/data",
    "#{node['tfly-artifactory']['home']}/logs:#{node['tfly-artifactory']['home']}/logs",
    "#{node['tfly-artifactory']['home']}/backup:#{node['tfly-artifactory']['home']}/backup"
  ]
end
