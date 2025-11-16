# InSpec tests for the alloy formula

# Check that the package is installed
describe package('alloy') do
  it { should be_installed }
end

# Check that the configuration file exists and has correct permissions
describe file('/etc/alloy/config.alloy') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0644' }
end

# Check that the service is running and enabled
describe service('alloy') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
