# Exact big-integer arithmetic with Vedic multiplication

**Goal:** multiply integers of any length exactly, then use that to compute **159!**, all 283 digits of it.

A MATLAB `double` keeps only about 16 significant digits, so the built-in `factorial(159)` gives `2.946702272495037e+282`. That is accurate in the first 15 or so digits and wrong in the rest. This project stores each number as a string of digits instead and multiplies them with the Vedic *"vertically and crosswise"* method, so every digit of the result is exact.

## The idea: multiplication is polynomial convolution

A number like 123 is the polynomial 1·x² + 2·x + 3 evaluated at x = 10. Multiplying two numbers is therefore the same as multiplying two polynomials, whose coefficients are

$$c_k = \sum_{i=\max(0,\,k-n)}^{\min(m,\,k)} a_i\, b_{k-i}, \qquad 0 \le k \le m+n$$

and then carrying in base 10.

```
myconv('123', '678')   →   '6  19  40  37  24'      (coefficients before carrying)
                       →   83394                    (after carrying: 123 × 678)
```

The Vedic method is the same calculation done by hand. Working from right to left, each output digit comes from the sum of the "crosswise" digit products whose positions add up to the same index, plus the carry from the step before:

| Step | Operation (12 × 34) | Type |
|---|---|---|
| 1 | 2 × 4 = **8** | vertical |
| 2 | 1 × 4 + 2 × 3 = **10** → write 0, carry 1 | crosswise |
| 3 | 1 × 3 + 1 = **4** | vertical |

Result: **408**. For an *m*-digit by *n*-digit product there are *m + n − 1* steps.

## Files

| File | Purpose |
|---|---|
| [`vedicmultiply.m`](vedicmultiply.m) | Multiplies two digit strings: diagonal sums, then a base-10 carry pass |
| [`myfactorial.m`](myfactorial.m) | Exact *n!* as a string, built from repeated `vedicmultiply` calls |
| [`myconv.m`](myconv.m) | Polynomial product of the digits (`conv`), shown before carrying |
| [`str2digits.m`](str2digits.m), [`digit2str.m`](digit2str.m) | Convert between `'1234'` and `[1 2 3 4]`, with input validation |
| [`demo.m`](demo.m) | Walks through every example below |

## Results

```
    12 x 34     = 408
     3 x 0      = 0
   456 x 23     = 10488
  7890 x 1234   = 9736260
  9999 x 9999   = 99980001

159! = 29467022724950383265043395073512148621949538940341262811056536144846410841
       71384877168612688988218723122267050655122476638168421183149385930893186799
       10943515696800488320990633099706213537627257021794896245353619886061381163
       6208208325279592585625600000000000000000000000000000000000000
159! has 283 digits
```

## How it's tested

[`tests/test_vedic_multiplication.m`](../tests/test_vedic_multiplication.m) checks:
- 200 random products against exact `uint64` arithmetic
- the full 283-digit value of 159! against an independent reference
- edge cases (`x 0`, leading zeros) and rejection of invalid input (`'12a'`, `-3`, `2.5`)

## Changes since the original submission

- `str2digits` and `digit2str` are vectorised: they use character arithmetic instead of calling `str2num` once per digit.
- `myconv` now reads the digits straight from the string. Before, it converted the string to a `double` first, which silently lost precision past 15 digits.
- Input validation was added, along with error identifiers that the tests can check.
