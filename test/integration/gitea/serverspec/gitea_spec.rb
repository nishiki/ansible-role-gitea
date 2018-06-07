require 'serverspec'

set :backend, :exec

describe user('gitea') do
  it { should exist }
  it { should have_uid 990 }
  it { should have_home_directory '/opt/gitea' }
  it { should have_login_shell '/bin/bash' }
end

describe file('/usr/local/bin/gitea') do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

%w[
  /opt/gitea
  /opt/gitea/data
  /opt/gitea/data/repositories
  /var/log/gitea
].each do |directory|
  describe file(directory) do
    it { should exist }
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'gitea' }
    it { should be_grouped_into 'gitea' }
  end
end

describe file('/opt/gitea/data/config.ini') do
  it { should exist }
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'gitea' }
  it { should be_grouped_into 'gitea' }
end

describe port(3000) do
  it { should be_listening }
end
