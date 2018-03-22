# certbot-dns
Scripts to use LetsEncrypt to create certs (including wildcard certs) using DNS challenge

The intention is to use seperate the DNS update method (e.g. aws route53) from the certbot script.  The current implementation only supports aws route53 but I will happily take pull requests for other DNS server implementations.

This solution was inspired by https://github.com/jed/certbot-route53 but enhanced to allow multiple DNS server types and for aws route53 perform updates in 1 large batch update to save time.

# Prerequisites
- certbot cli - https://certbot.eff.org/docs/install.html
- aws cli (if using aws route53 DNS server) - https://docs.aws.amazon.com/cli/latest/userguide/installing.html

# How to use

Copy file [example_gen_certs.sh] to another file as a template / starting point to generate your cert.

```
cp example_gen_certs.sh myserver_gen_certs.sh
vi myserver_gen_certs.sh
```

Update the `myserver_gen_certs.sh` file with the names of the DNS entries that should be in the cert.

