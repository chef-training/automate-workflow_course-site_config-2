# ##Inspec tests for base_web cookbook

control 'web-1.0' do
  impact 1.0
  title 'Web Server'
  desc 'Web server should answer with 200 reponse and be secure'

  describe bash 'curl localhost' do
    its('exit_status') { should eq 0 }
  end

  describe file('/etc/apache2/apache2.conf') do
    its(:content) { should_not match(/^\s+Options.*[\+\s]Indexes/) }
  end
end
