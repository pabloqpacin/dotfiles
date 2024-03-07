
- Arch

> https://wiki.archlinux.org/title/Metasploit_Framework

```bash

sudo pacman -Syu

# sudo pacman -S metasploit # lotta bloat

# msfconsole
```

---

<!--
- dockerfile

```dockerfile
FROM metasploitframework/metasploit-framework:6.3.47

```
-->

```bash
docker run -it --rm --name msf1 metasploitframework/metasploit-framework
```

> msfconsole

```bash
use auxiliary/scanner/ip/ipidseq
show options
info
set RHOSTS 192.168.1.38
run

# so... what the dawg doin!?

```
