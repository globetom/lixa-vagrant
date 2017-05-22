# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  if ENV['LIXA_VB_MEM']
    memory = ENV['LIXA_VB_MEM']
  else
    memory = '1024'
  end

  if ENV['LIXA_VB_CPU']
    cpus = ENV['LIXA_VB_CPU']
  else
    cpus = '2'
  end

  config.vm.box = 'centos/7'

  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = memory
    vb.cpus = cpus
  end

  config.vm.provider 'parallels' do |pl, override|
    # Change the box used for parallels
    override.vm.box = 'parallels/centos-6.8'
  end

  config.vm.provider 'azure' do |az, override|
    # Change the box used for parallels
    override.vm.box = 'azure'
    override.ssh.private_key_path = '~/.ssh/id_rsa'

    az.tenant_id = ENV['AZURE_TENANT_ID']
    az.client_id = ENV['AZURE_CLIENT_ID']
    az.client_secret = ENV['AZURE_CLIENT_SECRET']
    az.subscription_id = ENV['AZURE_SUBSCRIPTION_ID']
    az.vm_image_urn = 'OpenLogic:CentOS:7.3:latest'
    az.location = 'westus2'
  end

  if ENV['LIXA_VERSION']
    version = ENV['LIXA_VERSION']
  else
    version = '1.1.1'
  end

  if ENV['LIXA_RUN_TESTS']
    run_tests = ENV['LIXA_RUN_TESTS']
  else
    run_tests = false
  end

  config.vm.provision 'shell', path: 'provision.sh', env: {'version' => version, 'run_tests' => run_tests}, :args => ''
end
