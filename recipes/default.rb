# hostname setting
template "/etc/sysconfig/network" do
  source "network.erb"
  owner "root"
  group "root"
  mode "00644"
  variables({
    :hostname => node[:host_name],
    :domain => node[:domain_name],
    :gateway => node['network']['default_gateway']
  })
end

link "/etc/sysconfig/selinux" do
  to "/etc/selinux/config"
end

# selinux disabled
template "/etc/selinux/config" do
  source "selinux_config.erb"
  owner "root"
  group "root"
  mode "00644"
  variables({
    :value => node['centos']['selinux_value']
  })
  notifies :create, "link[/etc/sysconfig/selinux]", :immediately
end

# service stop
%w{cpid apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cups dhcdbd firstboot gpm hidd ip6tables iptables isdn mcstrans mdmonitor netfs nfslock pand pcscd portmap readahead_early restorecond rpcgssd rpcidmapd yum-updatesd xfs}.each do |service_name|
  service service_name do
    action [:disable, :stop]
  end
end

# disable ssh root loging
service "sshd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0600'
  notifies :reload, 'service[sshd]'
end
