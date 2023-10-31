# getdomains
Ruby code to grab domains from a forrest

Requires net-ldap:

gem install net-ldap

Pass the program the:
-s Server, IP address
-p Port, looking for global catalog, so 3268
-b Base DN, like "DC=example,DC=org"
-u User
-pw Password

Requires user and password or it won't work.  Assumption is you have this.

You can run:
nltest /dclist:yourdomain.com   To get a list of Domain Controllers

Or (for example on Kali):
nslookup -type=any _ldap._tcp.dc._msdcs.EXAMPLE.COM

Then run:
ruby getd.rb -s 192.168.1.1 -p 3268 -b "DC=example,DC=org" -u Bob -pw Password123

If connecting to the root of the forrest, will list the sub-domains as well.  Also now includes distinguishedName of user so that you can use an external app (like LDAP Browser) to connect to LDAP and view schema.


