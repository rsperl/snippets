find a user

```text
(&(objectCategory=person)(objectClass=user))
```

recursive group membership using LDAP_MATCHING_RULE_IN_CHAIN

```text
(&(objectCategory=person)(objectClass=user))(memberOf:1.2.840.113556.1.4.1941:=<groupdn>))
```

find all computer objects that are not disabled

```text
(&(objectCategory=computer)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
```

searching for bitmask flag:

-- bitwise AND -- all bits match this value

```text
(UserAccountControl:1.2.840.113556.1.4.803:=2)
```

ex - find all users with disable (2) and lockout (16) (not just one, but both flags)

```text
(UserAccountControl:1.2.840.113556.1.4.803:=18)
```

-- bitwise OR -- bitmask has this value

```text
(UserAccountControl:1.2.840.113556.1.4.804:=2)
```

ex - find all users with disable (2) OR lockout (16) (or both)

```text
(UserAccountControl:1.2.840.113556.1.4.804:=18)
```

UAC flag documentation: https://support.microsoft.com/en-us/kb/269181
UAC matching rule example: https://www.safaribooksonline.com/library/view/active-directory-cookbook/0596004648/ch04s10.html
