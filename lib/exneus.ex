defmodule Exneus do
  @type encode_options() :: %{
          optional(:codecs) => [:euneus_encoder.codec()],
          optional(:nulls) => [term()],
          optional(:skip_values) => [term()],
          optional(:key_to_binary) => (term() -> binary()),
          optional(:sort_keys) => boolean(),
          optional(:keyword_lists) => boolean() | {true, :euneus_encoder.is_proplist()},
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

  @spec encode!(term(), encode_options()) :: iodata()
  def encode!(term, opts \\ %{}) do
    :euneus.encode(term, norm_encode_opts(opts))
  end

  @spec encode_to_iodata!(term(), encode_options()) :: iodata()
  def encode_to_iodata!(term, opts \\ %{}) do
    :euneus.encode_to_iodata(term, norm_encode_opts(opts))
  end

  @spec norm_encode_opts(encode_options()) :: :euneus_encoder.options()
  defp norm_encode_opts(opts) do
    opts
    |> Map.put_new(:nulls, [nil])
    |> Map.put_new_lazy(:proplists, fn -> Map.get(opts, :keyword_lists, false) end)
  end
end
