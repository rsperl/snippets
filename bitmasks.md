## Does a mask have a certain bit set:

- mask & bit == bit => yes
- mask & bit == 0 => no

Example: do masks 514 or 512 have bit 2 set?

- set: 514 & 2 == 2
- not set: 512 & 2 == 0

## Add a bit to a mask:

mask | bit => mask + bit unless mask already has bit

Example: add bit 2 to mask 512

- 512 & 2 == 514
- 514 & 2 == 514

## Toggle a bit from a mask

mask ^ bit => new mask

Example: toggle bit 2 for masks 512 and 514

- 512 ^ 2 => 514
- 514 ^ 2 => 512

## Remove a bit

mask & ~bit == new mask without bit set

Example: remove bit 2 from mask 514

- 514 & ~2 == 512
- 512 & ~2 == 512 (no effect)
