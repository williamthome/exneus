# Exneus

[![Github Actions](https://github.com/williamthome/exneus/workflows/CI/badge.svg)](https://github.com/williamthome/exneus/actions)
[![Coverage](https://raw.githubusercontent.com/cicirello/jacoco-badge-generator/main/tests/100.svg)](https://github.com/williamthome/exneus/actions/workflows/ci.yml)
[![Elixir Versions](https://img.shields.io/badge/Elixir%2F-12%2B-purple?style=flat-square)](https://elixir-lang.org/)
[![Erlang Versions](https://img.shields.io/badge/Erlang%2FOTP-24%2B-green?style=flat-square)](http://www.erlang.org)
[![Latest Release](https://img.shields.io/github/release/williamthome/exneus.svg?style=flat-square)](https://github.com/williamthome/exneus/releases/latest)
[![Hex Version](https://img.shields.io/hexpm/v/exneus.svg)](https://hex.pm/packages/exneus)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/exneus/)
[![Total Download](https://img.shields.io/hexpm/dt/exneus.svg)](https://hex.pm/packages/exneus)
[![License](https://img.shields.io/hexpm/l/exneus.svg)](https://github.com/williamthome/exneus/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/williamthome/exneus.svg)](https://github.com/williamthome/exneus/commits/main)

An incredibly flexible and performant JSON parser, generator and formatter for Elixir.

Exneus is a wrapper for Elixir of [Euneus](https://github.com/williamthome/euneus),
an Erlang library built on the top of the new [OTP json module](https://erlang.org/documentation/doc-15.0-rc3/lib/stdlib-6.0/doc/html/json.html).

Both encoder and decoder fully conform to [RFC 8259](https://datatracker.ietf.org/doc/html/rfc8259)
and [ECMA 404](https://ecma-international.org/publications-and-standards/standards/ecma-404/) standards
and are tested using [JSONTestSuite](https://github.com/nst/JSONTestSuite).

Further explanation and examples are available at [hexdocs](https://hexdocs.pm/exneus).

## Installation

```elixir
def deps do
  [
    {:json_polyfill, "~> 0.1"}, # Required only for OTP < 27
    {:exneus, "~> 0.1"}
  ]
end
```

## Basic usage

```elixir
iex(1)> Exneus.encode!(%{name: "Joe Armstrong", age: 68, nationality: "British"})
"{\"name\":\"Joe Armstrong\",\"age\":68,\"nationality\":\"British\"}"
iex(2)> Exneus.decode!(v(1))
%{"age" => 68, "name" => "Joe Armstrong", "nationality" => "British"}
```

## Encode

Functions that provide JSON encoding:

- `Exneus.encode!/2`
- `Exneus.encode_to_iodata!/2`

## Decode

Functions that provide JSON decoding:

- `Exneus.decode!/2`

## Stream

Functions that provide JSON decode streaming:

- `Exneus.decode_stream_start!/2`
- `Exneus.decode_stream_continue!/2`
- `Exneus.decode_stream_end!/1`

## Format

Functions that provide JSON formatting:

- `Exneus.minify/1`
- `Exneus.minify_to_iodata/1`
- `Exneus.format/2`
- `Exneus.format_to_iodata/2`

## Benchmark

See [BENCHMARK.md](benchmark/BENCHMARK.md) for more information.

### Encode benchmark

```console
##### With input Blockchain #####
Name                 ips
euneus           36.95 K
json (OTP)       35.85 K - 1.03x slower +0.83 μs
Exneus           35.71 K - 1.03x slower +0.94 μs
jiffy            34.70 K - 1.06x slower +1.76 μs
Jason            26.75 K - 1.38x slower +10.32 μs
thoas            16.40 K - 2.25x slower +33.92 μs
jsone            15.52 K - 2.38x slower +37.38 μs
jsx               4.21 K - 8.77x slower +210.29 μs
JSON              3.88 K - 9.52x slower +230.47 μs

Memory usage statistics:

Name               average
euneus            84.20 KB
json (OTP)        82.66 KB - 0.98x memory usage -1.53125 KB
Exneus            84.13 KB - 1.00x memory usage -0.06250 KB
jiffy              7.79 KB - 0.09x memory usage -76.40625 KB
Jason             78.32 KB - 0.93x memory usage -5.87500 KB
thoas             89.41 KB - 1.06x memory usage +5.22 KB
jsone            178.56 KB - 2.12x memory usage +94.37 KB
jsx              397.30 KB - 4.72x memory usage +313.11 KB
JSON             481.30 KB - 5.72x memory usage +397.11 KB
```

### Decode benchmark

```console
##### With input Blockchain #####
Name                 ips
json (OTP)       18.79 K
euneus           18.06 K - 1.04x slower +2.16 μs
Exneus           17.68 K - 1.06x slower +3.34 μs
Jason            15.16 K - 1.24x slower +12.74 μs
jsone            13.82 K - 1.36x slower +19.17 μs
jiffy            12.76 K - 1.47x slower +25.15 μs
thoas            11.89 K - 1.58x slower +30.89 μs
jsx               4.93 K - 3.81x slower +149.64 μs
JSON              2.43 K - 7.74x slower +358.48 μs

Memory usage statistics:

Name               average
json (OTP)        35.95 KB
euneus            36.93 KB - 1.03x memory usage +0.98 KB
Exneus            37.05 KB - 1.03x memory usage +1.09 KB
Jason             51.63 KB - 1.44x memory usage +15.67 KB
jsone            131.70 KB - 3.66x memory usage +95.74 KB
jiffy              1.55 KB - 0.04x memory usage -34.40625 KB
thoas             51.41 KB - 1.43x memory usage +15.46 KB
jsx              315.84 KB - 8.78x memory usage +279.89 KB
JSON            1042.65 KB - 29.00x memory usage +1006.69 KB
```

## Sponsors

If you like this tool, please consider [sponsoring me](https://github.com/sponsors/williamthome).
I'm thankful for your never-ending support :heart:

I also accept coffees :coffee:

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/williamthome)

## License

Copyright (c) 2024 [William Fank Thomé](https://github.com/williamthome)

Exneus is 100% open-source and community-driven. All components are
available under the Apache 2 License on [GitHub](https://github.com/williamthome/exneus).

See [LICENSE.md](LICENSE.md) for more information.
