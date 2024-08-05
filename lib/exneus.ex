defmodule Exneus do
  def encode!(term, opts \\ %{}) do
    :euneus.encode(term, norm_encode_opts(opts))
  end

  def encode_to_iodata!(term, opts \\ %{}) do
    :euneus.encode_to_iodata(term, norm_encode_opts(opts))
  end

  defp norm_encode_opts(opts) do
    opts
    |> Map.put_new(:nulls, [nil])
    |> Map.put_new_lazy(:proplists, fn -> Map.get(opts, :keyword_lists, false) end)
  end
end
