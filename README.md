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
