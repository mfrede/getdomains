require 'net/ldap'
require 'optparse'

# call it: ruby your_script.rb -s your_server -p your_port

# Initialize Default Parameters
ldap_server = '127.0.0.1'
# Global Catalog Server
ldap_port = 3268    
# Base DN
ldap_base = "DC=example,DC=org"
# User
ldap_user = "anonymous"
ldap_pass = "password"

# OptionParser to handle command-line arguments
OptionParser.new do |opts|
  opts.on('-s', '--server SERVER', 'LDAP server address') do |server|
    ldap_server = server
  end

  opts.on('-p', '--port PORT', 'LDAP server port') do |port|
    ldap_port = port.to_i
  end

  opts.on('-b', '--base DN', 'LDAP base DN') do |base|
    ldap_base = base.to_s
  end

  opts.on('-u', '--user USER', 'LDAP user') do |user|
    ldap_user = user
  end

  opts.on('-pw', '--pw', 'LDAP password') do |pass|
    ldap_pass = pass
  end

end.parse!

# Connect to the global catalog
ldap = Net::LDAP.new(
  host: ldap_server,
  port: ldap_port,
  base: ldap_base, # Modify the base DN as needed
  auth: { 
    method: :simple,
    username: ldap_user,
    password: ldap_pass
   }
)
puts "LDAP Bind Status: " + ldap.bind.to_s

# Get Distinguished name of user
if ldap.bind
  filter = Net::LDAP::Filter.eq("cn", ldap_user)
  treebase = ldap_base
  ldap.search( :base => treebase, :filter =>filter) do |entry|
    puts "distinguishedName: #{entry[:distinguishedName]}"
  end
end

# Grab Domain information
if ldap.bind
  # Search for domain naming contexts
  #filter = Net::LDAP::Filter.eq("objectClass", "domainDNS")
  filter = Net::LDAP::Filter.eq("objectClass", "domain")
  ldap.search(filter: filter) do |entry|
    # Added 10/31/2023
    strDomain = ""
    dn = entry[:distinguishedName].to_s
    dn = dn.gsub('[', '')
    dn = dn.gsub(']','')
    dn = dn.gsub('"','')
    dnArray = dn.split(',')
    dnArray.each do |part|
      if strDomain.length == 0
        strDomain = strDomain + part[3, part.length - 3]
      else
        strDomain = strDomain + "." + part[3, part.length - 3]
      end
    end
    puts "Domain Name: #{entry[:dc].first}" + ", " + strDomain

  end
else
  puts "Failed to bind to the global catalog."
end