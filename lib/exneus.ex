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

  @spec decode!(binary(), decode_options()) :: term()
  @doc ~S"""
  Decodes a binary JSON into a term.

  ## Example

      iex> Exneus.decode!("\"foo\"")
      "foo"

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
    :euneus.minify(json)
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

  """
  def format(json, opts) do
    :euneus.format(json, opts)
  end
end
