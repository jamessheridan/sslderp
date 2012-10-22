sslderp

This is a simple utility to report things about remotely hosted SSL certs.

Presently, it will make a HTTPS connection to a given server and will report
the number of days remaning until that certificate expires. This is also why
it is named sslderp, as in - "OH, DERP, MY CERT EXPIRED!"

Example usage:
sslderp --target www.example.org --nagios

If you pass -n or --nagios to the utility, it will return Nagios/Icinga-
compatible exit codes if the certificate is close to expiry. <30 days will
generate a WARNING (exit 1), <15 days will generate a CRITICAL (exit 2) and
anything >30 days will return a clean 0.

