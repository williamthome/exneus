# Exneus

An incredibly flexible and performant JSON parser, generator and formatter for Elixir.

Exneus is built on top of [Euneus](https://github.com/williamthome/euneus):

> Euneus is built on the top of the new [OTP json module](https://erlang.org/documentation/doc-15.0-rc3/lib/stdlib-6.0/doc/html/json.html).
>
> Both encoder and decoder fully conform to [RFC 8259](https://datatracker.ietf.org/doc/html/rfc8259)
> and [ECMA 404](https://ecma-international.org/publications-and-standards/standards/ecma-404/) standards
> and are tested using [JSONTestSuite](https://github.com/nst/JSONTestSuite).
>
> Detailed examples and further explanation can be found at [hexdocs](https://hexdocs.pm/euneus).

## ⚠️ Disclaimer

Exneus is under development, so the documentation is incomplete and there is no package.

## Installation

```elixir
def deps do
  [
    {:exneus, git: "https://github.com/williamthome/exneus", branch: "main"}
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

![Encode run time](benchmark/assets/encode_run_time.png)

![Encode memory usage](benchmark/assets/encode_memory_usage.png)

### Decode

![Decode run time](benchmark/assets/decode_run_time.png)

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
