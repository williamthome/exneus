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

> - Operating System: Linux
> - CPU Information: 12th Gen Intel(R) Core(TM) i9-12900HX
> - Number of Available Cores: 24
> - Available memory: 31.09 GB
> - Elixir 1.17.2
> - Erlang 27.0.1
> - JIT enabled: true
>
> Benchmark suite executing with the following configuration:
>
> - warmup: 1 s
> - time: 10 s
> - memory time: 1 s
> - reduction time: 0 ns
> - parallel: 1
> - inputs: Blockchain

### Encode

Encode run time comparison:

![Encode run time](benchmark/assets/encode_run_time.png)

Encode memory usage comparison:

![Encode memory usage](benchmark/assets/encode_memory_usage.png)

### Decode

Decode run time comparison:

![Decode run time](benchmark/assets/decode_run_time.png)

Decode memory usage comparison:

![Decode memory usage](benchmark/assets/decode_memory_usage.png)

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
