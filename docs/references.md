# References

Every number the library takes from outside is recorded here with its source. A value in the code
that is not in this file is a choice, marked CHOICE where it is made.

## ISO 4796-1:2016 (primary)

ISO 4796-1:2016, _Laboratory glassware — Bottles — Part 1: Screw-neck bottles_, second edition,
2016-01-15. It replaces the 2000 edition and adds 150 mL, 750 mL and 3.5 L. Read 2026-09-27 from the
publisher's sample, which carries the whole normative text:
<https://cdn.standards.iteh.ai/samples/63920/9973946609e34343a221f41585d1de23/ISO-4796-1-2016.pdf>

### Table 1

All values in mm. h1, h2 and d1 are marked approximate; s and d2 are minima.

| Nominal mL | h1 total height | h2 height to shoulder | d1 outside diameter | s wall | d2 internal neck |
| ---------- | --------------- | --------------------- | ------------------- | ------ | ---------------- |
| 25         | 70              | 41                    | 36                  | 1.0    | 12.5             |
| 50         | 87              | 50                    | 46                  | 1.0    | 15               |
| 100        | 100             | 60                    | 56                  | 1.5    | 27               |
| 150        | 110             | 70                    | 62                  | 1.5    | 27               |
| 250        | 138             | 90                    | 70                  | 1.5    | 27               |
| 500        | 176             | 110                   | 86                  | 1.5    | 27               |
| 750        | 204             | 133                   | 95                  | 1.7    | 27               |
| 1 000      | 225             | 153                   | 101                 | 1.7    | 27               |
| 2 000      | 260             | 170                   | 136                 | 2.0    | 27               |
| 3 500      | 295             | 184                   | 161                 | 2.0    | 27               |
| 5 000      | 330             | 208                   | 181                 | 2.0    | 27               |
| 10 000     | 410             | 265                   | 227                 | 2.7    | 27               |
| 15 000     | 445             | 285                   | 268                 | 2.7    | 27               |
| 20 000     | 505             | 330                   | 288                 | 3.0    | 27               |

### The clauses the library reads

- **3.1** the capacity series, 25 mL to 20 L, in the order above.
- **3.2** nominal capacity is what a bottle of average wall holds filled to the turn of the shoulder.
- **3.3** filled to the base of the neck it holds about 15 % more.
- **5.2.2** the base has "a suitable radius"; the side is cylindrical from 25 mL to 2 L and slightly
  tapered from 3.5 L to 20 L, narrower at the base. Figure 2 gives the taper as 1:30.
- **5.2.3** the shoulder has "a suitable radius" into a conical upper part.
- **5.2.4** the upper part is a cone; the shoulder-to-neck radius is as small as manufacture allows.
  Figure 2 (3.5 L to 20 L) draws the cone at 90° included. Figure 1 (25 mL to 2 L) draws one and
  does not dimension it.
- **5.2.6** the neck carries a lip or a channel for a clip-on pouring ring. A note leaves the thread
  to national standards, which for these bottles is DIN 168 (see din168-thread-scad).

The standard does not give the neck's height, the thread's length or position, the lip, the corner
radii or the base's thickness or recess. Where the drawing is ambiguous — which diameter of a tapered
body d1 is — the library says so at the choice.

## DURAN Original GL 45 (DWK Life Sciences)

_DURAN® Original GL 45 bottle_, order information sheet, PDF created 2018-06-01:
<https://www.duran-bottle-system.com/files/Downloads/order_info_bottles/DURAN_Original_GL45_EN.pdf>
Read 2026-09-27. DWK states the range complies with ISO 4796-1:2016, the 10 mL bottle excepted.

Without cap and pouring ring (d is the outside diameter, h the height; mm):

| Cat. No.     | mL     | GL  | d   | h   |
| ------------ | ------ | --- | --- | --- |
| 21 801 08 02 | 10     | 25  | 36  | 50  |
| 21 801 14 04 | 25     | 25  | 36  | 70  |
| 21 801 17 04 | 50     | 32  | 46  | 87  |
| 21 801 24 09 | 100    | 45  | 56  | 100 |
| 21 801 29 06 | 150    | 45  | 62  | 110 |
| 21 801 36 02 | 250    | 45  | 70  | 138 |
| 21 801 44 01 | 500    | 45  | 86  | 176 |
| 21 801 51 06 | 750    | 45  | 95  | 203 |
| 21 801 54 06 | 1 000  | 45  | 101 | 225 |
| 21 801 63 08 | 2 000  | 45  | 136 | 260 |
| 21 801 69 08 | 3 500  | 45  | 160 | 295 |
| 21 801 73 04 | 5 000  | 45  | 182 | 330 |
| 21 801 86 09 | 10 000 | 45  | 227 | 410 |
| 21 801 88 06 | 15 000 | 45  | 268 | 445 |
| 21 801 91 08 | 20 000 | 45  | 288 | 505 |

Against Table 1: h is h1 for every size but 750 mL (203 against 204); d is d1 but for 3.5 L (160
against 161) and 5 L (182 against 181). With cap and pouring ring, h is 4 or 5 mm more. The sheet
also lists a 25 L bottle, which is outside the standard. **This is where the thread per size comes
from:** GL25 at 25 mL, GL32 at 50 mL, GL45 from 100 mL up.

Brim capacity, from DWK's product page for each catalogue number with cap (read 2026-09-27; the
page gives none for 750 mL, 15 L or 20 L), in mL:

| mL    | 25 | 50 | 100 | 150 | 250 | 500 | 1 000 | 2 000 | 3 500 | 5 000 | 10 000 |
| ----- | -- | -- | --- | --- | --- | --- | ----- | ----- | ----- | ----- | ------ |
| brim  | 34 | 70 | 138 | 190 | 310 | 619 | 1 150 | 2 265 | 3 980 | 5 950 | 11 220 |

e.g. <https://www.dwk.com/na/duran-original-gl-45-laboratory-bottle-clear-with-screw-cap-and-pouring-ring-pp-blue-1000-ml-218015455>

## KIMBLE KIMAX GL45 media bottles (DWK Life Sciences)

<https://www.dwk.com/na/kimble-gl45-media-bottles>, read 2026-09-27. Catalogue 14395 (with cap) and
14396 (without): 100, 250, 500, 1000, 2000, 5000 and 10 000 mL, whose OD and height are Table 1's
d1 and h1 exactly, 5 L at 181 x 330. The page gives the opening as **"30 mm ID"**. Each size's
own product page (e.g. `14395-500`) gives OD, height and graduations but no brim capacity, and the
same height with cap as without.

## Neck bores

Adams & Chittenden Scientific Glass, _GL Threads_, <https://adamschittenden.com/technical/connections/gl-threads>,
read 2026-09-27. Inside diameters of GL finishes moulded on bottles:

| Finish             | ID (mm) |
| ------------------ | ------- |
| GL25, 25 mL bottle | 14.3    |
| GL32, 50 mL bottle | 17      |
| GL45, 100 mL bottle | 30     |

The GL45 figure agrees with Kimble's. The library takes these as each finish's bore, on every size
that carries it. All three clear Table 1's d2.

## Findings

What the drawn bottles hold, from `iso4796_report()` with the choices as shipped:

| mL     | to shoulder, % of nominal | to neck, % of nominal (3.3: ~115) | cone, deg included |
| ------ | ------------------------- | --------------------------------- | ------------------ |
| 25     | 141                       | 172                               | 63                 |
| 50     | 145                       | 177                               | 67                 |
| 100    | 125                       | 156                               | 46                 |
| 150    | 122                       | 145                               | 68                 |
| 250    | 122                       | 147                               | 63                 |
| 500    | 115                       | 143                               | 57                 |
| 750    | 113                       | 137                               | 61                 |
| 1 000  | 111                       | 132                               | 66                 |
| 2 000  | 113                       | 136                               | 76                 |
| 3 500  | 95                        | 118                               | 73 (Figure 2: 90)  |
| 5 000  | 96                        | 118                               | 75 (Figure 2: 90)  |
| 10 000 | 95                        | 116                               | 80 (Figure 2: 90)  |
| 15 000 | 96                        | 119                               | 86 (Figure 2: 90)  |
| 20 000 | 96                        | 117                               | 85 (Figure 2: 90)  |

The tapered sizes land within 5 % of the standard's capacities, with the cone the fit found near
Figure 2's. The small ones hold far too much, and not because of a choice the library could tune: a
bare cylinder of d1 at the minimum wall, filled to h2, already holds 113-49 % of nominal from 25 mL
to 2 L, where it holds 101-2 % from 3.5 L up. Duran's brim capacities say the same from the other
side - its 100 mL bottle holds 138 mL to the brim, the drawn one 156 mL to the neck alone. Small
moulded bottles carry far more glass than s, most likely in the base; a measured bottle settles it.

The DURAN rows carry DWK's brim capacities, so the report measures them to the rim as well:

| mL    | 25  | 50  | 100 | 150 | 250 | 500 | 1 000 | 2 000 | 3 500 | 5 000 | 10 000 |
| ----- | --- | --- | --- | --- | --- | --- | ----- | ----- | ----- | ----- | ------ |
| rim % | 135 | 135 | 126 | 124 | 124 | 118 | 116   | 121   | 103   | 101   | 104    |

From 3.5 L up the drawn bottle is within 4 % of DWK's own figure; below that it is 16-35 % over,
the same excess as against the standard.
