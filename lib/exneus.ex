defmodule Exneus do
  @moduledoc ~S"""
  An incredibly flexible and performant JSON parser, generator and formatter for Elixir.
  """

  @type encode_options() :: %{
          optional(:codecs) => [:euneus_encoder.codec()],
          optional(:codec_callback) => :euneus_encoder.codec_callback(),
          optional(:nulls) => [term()],
          optional(:skip_values) => [term()],
          optional(:key_to_binary) => (term() -> binary()),
          optional(:sort_keys) => boolean(),
          optional(:keyword_lists) => boolean() | {true, is_keyword_list()},
          optional(:escape) => (binary() -> iodata()),
          optional(:encode_integer) => :euneus_encoder.encode(integer()),
          optional(:encode_float) => :euneus_encoder.encode(float()),
          optional(:encode_atom) => :euneus_encoder.encode(atom()),
          optional(:encode_list) => :euneus_encoder.encode(list()),
          optional(:encode_map) => :euneus_encoder.encode(map()),
          optional(:encode_tuple) => :euneus_encoder.encode(tuple()),
          optional(:encode_pid) => :euneus_encoder.encode(pid()),
          optional(:encode_port) => :euneus_encoder.encode(port()),
          optional(:encode_reference) => :euneus_encoder.encode(reference()),
          optional(:encode_term) => :euneus_encoder.encode(term())
        }

  @type is_keyword_list() :: :euneus_encoder.is_proplist()

  @spec encode!(term(), encode_options()) :: iodata()
  @doc ~S"""
  Encodes a term into a binary JSON.

  ## Example

      iex> Exneus.encode!(:foo)
      "\"foo\""

  ## Option details

  > #### Note {: .info}
  >
  > For better visualization and understanding, all options examples use
  > `Exneus.encode!/2`, which returns a binary.

  - `codecs` - Transforms tuples into any other Erlang term that will be encoded
    again into a JSON value. By returning `:next`, the next codec will be called,
    or by returning `{:halt, term :: term()}`, the term will be encoded again.

    You can use the built-in codecs or your own.
    Please see the `t::euneus_encoder.codec/0` type for details.

    Default is `[]`.

    Built-in codecs:

    - `timestamp` - Transforms an `t::erlang.timestamp/0` into an ISO 8601 string
      with milliseconds.

      _Example:_

          iex> Exneus.encode!({0, 0, 0}, %{codecs: [:timestamp]})
          "\"1970-01-01T00:00:00.000Z\""

    - `datetime` - Transforms a `t::calendar.datetime/0` into an ISO 8601 string.

      _Example:_

          iex> Exneus.encode!({{1970, 01, 01}, {00, 00, 00}}, %{codecs: [:datetime]})
          "\"1970-01-01T00:00:00Z\""

    - `ipv4` - Transforms an `t::inet.ip4_address/0` into a JSON string.

      _Example:_

          iex> Exneus.encode!({127, 0, 0, 1}, %{codecs: [:ipv4]})
          "\"127.0.0.1\""

    - `ipv6` - Transforms an `t::inet.ip6_address/0` into a JSON string.

      _Example:_

          iex> Exneus.encode!({0, 0, 0, 0, 0, 0, 0, 0}, %{codecs: [:ipv6]})
          "\"::\""
          iex> Exneus.encode!({0, 0, 0, 0, 0, 0, 0, 1}, %{codecs: [:ipv6]})
          "\"::1\""
          iex> Exneus.encode!({0, 0, 0, 0, 0, 0, 49320, 10754}, %{codecs: [:ipv6]})
          "\"::192.168.42.2\""
          iex> Exneus.encode!({0, 0, 0, 0, 0, 65535, 49320, 10754}, %{codecs: [:ipv6]})
          "\"::ffff:192.168.42.2\""
          iex> Exneus.encode!({16382, 2944, 8077, 2, 516, 44287, 65047, 48952}, %{codecs: [:ipv6]})
          "\"3ffe:b80:1f8d:2:204:acff:fe17:bf38\""
          iex> Exneus.encode!({65152, 0, 0, 0, 516, 44287, 65047, 48952}, %{codecs: [:ipv6]})
          "\"fe80::204:acff:fe17:bf38\""

    - `records` - Transforms records into JSON objects.

      _Example:_

          iex> Exneus.encode!(
          ...>   # Same as `Record.defrecord(:foo, :bar, :baz)`
          ...>   {:foo, :bar, :baz},
          ...>   %{codecs: [{:records, %{
          ...>       # Use `Record.extract/2` to extract those record informations
          ...>       foo: {[:bar, :baz], 3}
          ...>   }}]}
          ...> )
          if String.to_integer(System.otp_release) >= 26 do
            "{\"bar\":\"bar\",\"baz\":\"baz\"}"
          else
            "{\"baz\":\"baz\",\"bar\":\"bar\"}"
          end

    Custom codec example:

        iex> Exneus.encode!({:foo}, %{codecs: [fn ({:foo}) -> {:halt, :foo} end]})
        "\"foo\""

  - `codec_callback` - Overrides the default codec resolver.

    Default is `euneus_encoder.codec_callback/2`.

  - `nulls` - Defines which values should be encoded as null.

    Default is `[nil]`.

    _Example:_

        iex> Exneus.encode!([:null, nil, :foo], %{nulls: [:null, nil]})
        "[null,null,\"foo\"]"

  - `skip_values` - Defines which map values should be ignored.
    This option permits achieves the same behavior as Javascript,
    which ignores undefined values of objects.

    Default is `[]`.

    _Example:_

        iex> Exneus.encode!(
        ...>   %{foo: :bar, bar: :undefined},
        ...>   %{skip_values: [:undefined]}
        ...> )
        "{\"foo\":\"bar\"}"

  - `key_to_binary` - Overrides the default conversion of map keys to a string.

    Default is `:euneus_encoder.key_to_binary/1` .

  - `sort_keys` - Defines if the object keys should be sorted.

    Default is `false`.

    _Example:_

        iex> Exneus.encode!(%{c: :c, a: :a, b: :b}, %{sort_keys: true})
        "{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}"

  - `keyword_lists` - If true, converts keyword_lists into objects.

    Default is `false`.

    _Example:_

        iex> Exneus.encode!([:baz, foo: :bar], %{keyword_lists: true})
        "{\"foo\":\"bar\",\"baz\":true}"
        iex> Exneus.encode!(
        ...>     [foo: :bar, baz: true],
        ...>     # Overrides the default is keyword list check:
        ...>     %{keyword_lists: {true, fn ([{_, _} | _]) -> true end}}
        ...> )
        "{\"foo\":\"bar\",\"baz\":true}"

  - `escape` - Overrides the default string escaping.

    Default is `:euneus_encoder.escape/1`.

  - `encode_integer` - Overrides the default integer encoder.

    Default is `:euneus_encoder.encode_integer/2`.

  - `encode_float` - Overrides the default float encoder.

    Default is `:euneus_encoder.encode_float/2`.

  - `encode_atom` - Overrides the default atom encoder.

    Default is `:euneus_encoder.encode_atom/2`.

  - `encode_list` - Overrides the default list encoder.

    Default is `:euneus_encoder.encode_list/2`.

  - `encode_map` - Overrides the default map encoder.

    Default is the private function Exneus.encode_map/2.

  - `encode_tuple` - Overrides the default tuple encoder.

    Default is `:euneus_encoder.encode_tuple/2`, which raises
    `:unsupported_tuple` error.

  - `encode_pid` - Overrides the default pid encoder.

    Default is `:euneus_encoder.encode_pid/2`, which raises
    `:unsupported_pid` error.

  - `encode_port` - Overrides the default port encoder.

    Default is `:euneus_encoder.encode_port/2`, which raises
    `:unsupported_port` error.

  - `encode_reference` - Overrides the default reference encoder.

    Default is `:euneus_encoder.encode_reference/2`, which raises
    `:unsupported_reference` error.

  - `encode_term` - Overrides the default encoder for unsupported terms,
    like functions.

    Default is `:euneus_encoder.encode_term/2`, which raises
    `:unsupported_term` error.
  """
  def encode!(term, opts \\ %{}) do
    :erlang.iolist_to_binary(:euneus_encoder.encode(term, norm_encode_opts(opts)))
  end

  @spec encode_to_iodata!(term(), encode_options()) :: iodata()
  @doc ~S"""
  Encode a term into an iodata JSON.

  ## Example

      iex> Exneus.encode_to_iodata!(:foo)
      [?", "foo", ?"]

  """
  def encode_to_iodata!(term, opts \\ %{}) do
    :euneus_encoder.encode(term, norm_encode_opts(opts))
  end

  @spec norm_encode_opts(encode_options()) :: :euneus_encoder.options()
  defp norm_encode_opts(opts) do
    opts
    |> Map.put_new(:nulls, [nil])
    |> Map.put_new(:skip_values, [])
    |> Map.put_new_lazy(:proplists, fn -> Map.get(opts, :keyword_lists, false) end)
    |> Map.put_new(:encode_map, &encode_map/2)
  end

  defp encode_map(struct, state) when is_map_key(struct, :__struct__) do
    :euneus_encoder.encode_map(Map.from_struct(struct), state)
  end

  defp encode_map(map, state) do
    :euneus_encoder.encode_map(map, state)
  end

  @type decode_options() :: %{
          optional(:codecs) => [:euneus_decoder.codec()],
          optional(:null) => term(),
          optional(:binary_to_float) => :json.from_binary_fun(),
          optional(:binary_to_integer) => :json.from_binary_fun(),
          optional(:array_start) => :json.array_start_fun(),
          optional(:array_push) => :json.array_push_fun(),
          optional(:array_finish) =>
            :ordered
            | :reversed
            | :json.array_finish_fun(),
          optional(:object_start) => :json.object_start_fun(),
          optional(:object_keys) =>
            :binary
            | :copy
            | :atom
            | :existing_atom
            | :json.from_binary_fun(),
          optional(:object_push) => :json.object_push_fun(),
          optional(:object_finish) =>
            :map
            | :keyword_list
            | :reversed_keyword_list
            | :json.object_finish_fun()
        }

  @spec decode!(json, options) :: term()
        when json: binary(),
             options: decode_options()
  @doc ~S"""
  Decodes a binary JSON into a term.

  ## Example

      iex> Exneus.decode!("\"foo\"")
      "foo"

  ## Option details

  - `codecs` - Transforms a JSON binary value into an Erlang term.
    By returning `:next`, the next codec will be called, or by returning
    `{:halt, term :: term()}`, the term is returned as the value.

    You can use the built-in codecs or your own.
    Please see the `t::euneus_decoder.codec/0` type for details.

    Default is `[]`.

    Built-in codecs:

    - `timestamp` - Transforms an ISO 8601 string with milliseconds into
      an `t::erlang.timestamp/0`.

      _Example:_

          iex> Exneus.decode!("\"1970-01-01T00:00:00.000Z\"", %{codecs: [:timestamp]})
          {0, 0, 0}

    - `datetime` - Transforms an ISO 8601 string into a `t::calendar.datetime/0`.

      _Example:_

          iex> Exneus.decode!("\"1970-01-01T00:00:00Z\"", %{codecs: [:datetime]})
          {{1970, 01, 01},{00, 00, 00}}

    - `ipv4` - Transforms a JSON string into an `t::inet.ip4_address/0`.

      _Example:_

          iex> Exneus.decode!("\"127.0.0.1\"", %{codecs: [:ipv4]})
          {127, 0, 0, 1}

    - `ipv6` - Transforms a JSON string into an `t::inet.ip6_address/0`.

      _Example:_

          iex> Exneus.decode!("\"::\"", %{codecs: [:ipv6]})
          {0, 0, 0, 0, 0, 0, 0, 0}
          iex> Exneus.decode!("\"::1\"", %{codecs: [:ipv6]})
          {0, 0, 0, 0, 0, 0, 0, 1}
          iex> Exneus.decode!("\"::192.168.42.2\"", %{codecs: [:ipv6]})
          {0, 0, 0, 0, 0, 0, 49320, 10754}
          iex> Exneus.decode!("\"::ffff:192.168.42.2\"", %{codecs: [:ipv6]})
          {0, 0, 0, 0, 0, 65535, 49320, 10754}
          iex> Exneus.decode!("\"3ffe:b80:1f8d:2:204:acff:fe17:bf38\"", %{codecs: [:ipv6]})
          {16382, 2944, 8077, 2, 516, 44287, 65047, 48952}
          iex> Exneus.decode!("\"fe80::204:acff:fe17:bf38\"", %{codecs: [:ipv6]})
          {65152, 0, 0, 0, 516, 44287, 65047, 48952}

    - `pid` - Transforms a JSON string into an `t::erlang.pid/0`.

      _Example:_

          iex> Exneus.decode!("\"<0.92.0>\"", %{codecs: [:pid]})
          ...> == :erlang.list_to_pid(~c"<0.92.0>")
          true

    - `port` - Transforms a JSON string into an `t::erlang.port/0`.

      _Example:_

          iex> Exneus.decode!("\"#Port<0.1>\"", %{codecs: [:port]})
          ...> == :erlang.list_to_port(~c"#Port<0.1>")
          true

    - `reference` - Transforms a JSON string into an `t::erlang.reference/0`.

      _Example:_

          iex> Exneus.decode!("\"#Ref<0.314572725.1088159747.110918>\"", %{codecs: [:reference]})
          ...> == :erlang.list_to_ref(~c"#Ref<0.314572725.1088159747.110918>")
          true

    Custom codec example:

        iex> Exneus.decode!("\"foo\"", %{codecs: [fn ("foo") -> {:halt, :foo} end]})
        :foo

  - `null` - Defines which term should be considered null.

    Default is `nil`.

    _Example:_

        iex> Exneus.decode!("null", %{null: :null})
        :null

  - `binary_to_float` - Overrides the default binary to float conversion.

  - `binary_to_integer` - Overrides the default binary to integer conversion..

  - `array_start` - Overrides the `t::json.array_start_fun/0` callback.

  - `array_push` - Overrides the `t::json.array_push_fun/0` callback.

  - `array_finish` - Overrides the `t::json.array_finish_fun/0` callback.

    In addition to the custom function, there are:

    - `ordered` - Returns the array in the same order as the JSON.

      That's the slower option.

      _Example:_

          iex> Exneus.decode!("[1,2,3]", %{array_finish: :ordered})
          [1,2,3]

    - `reversed` - Returns the array in a reversed order.

      That's the faster option.

      _Example:_

          iex> Exneus.decode!("[1,2,3]", %{array_finish: :reversed})
          [3,2,1]

    Default is `ordered`.

  - `object_start` - Overrides the `t::json.object_start_fun/0` callback.

  - `object_keys` - Transforms JSON objects key into Erlang term.

    In addition to the custom function, there are:

    - `binary` - Returns the key as `t::erlang.binary/0`.
    
    - `copy` - Copies the key via `:binary.copy/1` returning it as `t::erlang.binary/0`.

    - `atom` - Returns the key as `t::erlang.atom/0` via `:erlang.binary_to_atom/2`.

    - `existing_atom` - Returns the key as `t::erlang.atom/0` via
      `:erlang.binary_to_existing_atom/2`.

    Default is `binary`.

  - `object_push` - Overrides the `t::json.object_push_fun/0` callback.

  - `object_finish` - Overrides the `t::json.object_finish_fun/0` callback.

    In addition to the custom function, there are:

    - `map` - Returns the object as a `t::erlang.map/0`.

      That's the slower option.

      _Example:_

          iex> Exneus.decode!(
          ...>   "{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}",
          ...>   %{object_finish: :map}
          ...> )
          %{<<"a">> => <<"a">>,<<"b">> => <<"b">>,<<"c">> => <<"c">>}

    - `keyword_list` - Returns the object as an ordered `t:keyword/0`.

      _Example:_

          iex> Exneus.decode!(
          ...>   "{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}",
          ...>   %{object_finish: :keyword_list}
          ...> )
          [{"a", "a"},{"b", "b"},{"c", "c"}]

    - `reversed_keyword_list` - Returns the object as a reversed `t:keyword/0`.

      That's the faster option.

      _Example:_

          iex> Exneus.decode!(
          ...>   "{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}",
          ...>   %{object_finish: :reversed_keyword_list}
          ...> )
          [{"c", "c"},{"b", "b"},{"a", "a"}]

    Default is `map`.
  """
  def decode!(json, opts \\ %{}) do
    :euneus_decoder.decode(json, norm_decode_opts(opts))
  end

  @spec norm_decode_opts(decode_options()) :: :euneus_decoder.options()
  defp norm_decode_opts(opts) do
    opts
    |> Map.put_new(:null, nil)
    |> Map.put(:object_finish, object_finish_decoder(Map.get(opts, :object_finish, :map)))
  end

  defp object_finish_decoder(:keyword_list) do
    :proplist
  end

  defp object_finish_decoder(:reversed_keyword_list) do
    :reversed_proplist
  end

  defp object_finish_decoder(decoder) do
    decoder
  end

  @spec decode_stream_start!(json, options) :: result
        when json: binary(),
             options: :euneus_decoder.options(),
             result: :euneus_decoder.stream_result()

  @doc ~S"""
  Begin parsing a stream of bytes of a JSON value.
  """
  def decode_stream_start!(json, opts \\ %{}) do
    :euneus_decoder.stream_start(json, norm_decode_opts(opts))
  end

  @spec decode_stream_continue!(json, state) :: result
        when json: binary() | :end_of_input,
             state: :euneus_decoder.stream_state(),
             result: :euneus_decoder.stream_result()

  @doc ~S"""
  Continue parsing a stream of bytes of a JSON value.

  ## Example

      iex> {:continue, state} = Exneus.decode_stream_start!("{\"foo\":")
      iex> Exneus.decode_stream_continue!("1}", state)
      {:end_of_input, %{"foo" => 1}}

  """
  def decode_stream_continue!(json, state) do
    :euneus_decoder.stream_continue(json, state)
  end

  @spec decode_stream_end!(state) :: result
        when state: :euneus_decoder.stream_state(),
             result: {:end_of_input, term()}

  @doc ~S"""
  End parsing a stream of bytes of a JSON value.

  ## Example

      iex> {:continue, state} = Exneus.decode_stream_start!("123")
      iex> Exneus.decode_stream_end!(state)
      {:end_of_input, 123}

  """
  def decode_stream_end!(state) do
    :euneus.decode_stream_end(state)
  end

  @spec minify(json) :: binary()
        when json: binary()
  @doc ~S"""
  Minifies a binary JSON.

  ## Example

      iex> Exneus.minify(" \n{\"foo\"  :  [ true  , \n null ] \n  }  ")
      "{\"foo\":[true,null]}"

  """
  def minify(json) do
    :erlang.iolist_to_binary(minify_to_iodata(json))
  end

  @spec minify_to_iodata(json) :: iodata()
        when json: binary()
  @doc ~S"""
  Minifies a binary JSON.
  """
  def minify_to_iodata(json) do
    :euneus.minify_to_iodata(json)
  end

  @spec format(json, options) :: binary()
        when json: binary(),
             options: :euneus_formatter.options()
  @doc ~S"""
  Formats a binary JSON.

  ## Example

      iex> opts = %{
      ...>   indent_type: :tabs,
      ...>   indent_width: 1,
      ...>   spaced_values: true,
      ...>   crlf: :n
      ...> }
      %{crlf: :n, indent_type: :tabs, indent_width: 1, spaced_values: true}
      iex> Exneus.format(" \n{\"foo\"  :  [ true  , \n null ] \n  }  ", opts)
      "{\n\t\"foo\": [\n\t\ttrue,\n\t\tnull\n\t]\n}"

  ## Option details

  > #### Note {: .info}
  >
  > There is no default for any option, all are required.

  - `indent_type` - Indent using `tabs` or `spaces`.

    - `tabs` - The indent char will be `?\t`.

    - `spaces` - The indent char will be `?\s`.

  - `indent_width` - The `indent_type` will be copied N times based on it.

  - `spaced_values` - Defines if keys and values of objects should be
    spaced by one `?\s` char.

  - `crlf` - Defines the Carriage Return/Line Feed.

    - `r` - The CRLF will be `"\r"`.

    - `n` - The CRLF will be `"\n"`.

    - `rn` - The CRLF will be `"\r\n"`.

    - `none` - The CRLF will be `""`.
  """
  def format(json, opts) do
    :erlang.iolist_to_binary(format_to_iodata(json, opts))
  end

  @spec format_to_iodata(json, options) :: iodata()
        when json: binary(),
             options: :euneus_formatter.options()
  @doc ~S"""
  Formats a binary JSON.
  """
  def format_to_iodata(json, opts) do
    :euneus.format_to_iodata(json, opts)
  end
end
