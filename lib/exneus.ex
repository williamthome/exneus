defmodule Exneus do
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
    |> Map.put_new(:skip_values, [])
    |> Map.put_new_lazy(:proplists, fn -> Map.get(opts, :keyword_lists, false) end)
    |> Map.put_new(:encode_map, &encode_map/2)
  end

  def encode_map(struct, state) when is_map_key(struct, :__struct__) do
    :euneus_encoder.encode_map(Map.from_struct(struct), state)
  end

  def encode_map(map, state) do
    :euneus_encoder.encode_map(map, state)
  end

  def decode!(json, opts \\ %{}) do
    :euneus_decoder.decode(json, norm_decode_opts(opts))
  end

  defp norm_decode_opts(opts) do
    opts
    |> Map.put_new(:null, nil)
    |> Map.put(:object_finish, object_finish_decoder(Map.get(opts, :object_finish, :map)))
  end

  defp object_finish_decoder(:map) do
    fn acc, old_acc -> {:maps.from_list(acc), old_acc} end
  end

  defp object_finish_decoder(:keyword_list) do
    fn acc, old_acc -> {:lists.reverse(acc), old_acc} end
  end

  defp object_finish_decoder(:reversed_keyword_list) do
    fn acc, old_acc -> {acc, old_acc} end
  end

  defp object_finish_decoder(decoder) when is_function(decoder, 2) do
    decoder
  end
end
