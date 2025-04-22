server.modules = (
    "mod_access",
    "mod_cgi",
    "mod_alias"
)

server.document-root = "/var/www/localhost/htdocs"
server.port = ${PORT}

# CGI configuration
alias.url += ("/cgi-bin/" => "/var/www/cgi-bin/")
cgi.assign = (".sh" => "/bin/sh")

# Logging
server.errorlog = "/var/log/lighttpd/error.log"

# Server user and group
server.username = "appuser"
server.groupname = "appuser"

# Index file
index-file.names = ("index.html")
