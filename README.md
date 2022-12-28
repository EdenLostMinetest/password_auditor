# Minetest Password Auditor

Registers a chat command, `xban_no_password` that uses `xban2` to ban all
accounts with no password, or with the password equal to the username.

Accounts are banned with the messages "account has no password" or "account has
a weak password". A player with a banned account can create a new account, and
if they want access to their old one, can contact the admin (in game, via
`/mail`), and if their current and previous historic IP addresses match, then I
can (no promise that I will though) unban the account and force the user to set
a password on it.

Ideally, a Minetest server would be configured with
`disallow_empty_password = true` in its minetest.conf file.

## Rationale

Why does this mod exist? Because I assumed admin responsibilities over a
semi-active public server that did not require passwords on user accounts. This
server has ~19k accounts, ~10k with no password and ~100 with the password equal
to the username. Along comes a malicious player who has compiled a list of
recently active players and has been siezing control over their accounts. Worse,
they are using a VPN, so banning IPs to stop the damage is not working. I wrote
this mod to preserve the survivng accounts.
