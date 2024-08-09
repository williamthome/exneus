Code.eval_file("exneus_benchmark.exs", "./benchmark")

jobs = %{
  "Exneus" => &Exneus.encode_to_iodata!/1,
  "euneus" => fn term -> :euneus.encode_to_iodata(term, %{nulls: [nil]}) end,
  "json (OTP)" => &:json.encode/1,
  "thoas" => &:thoas.encode_to_iodata/1,
  "Jason" => &Jason.encode_to_iodata/1,
  "JSON" => &JSON.encode!/1,
  "jsone" => &:jsone.encode/1,
  "jsx" => &:jsx.encode/1,
  "jiffy" => fn term -> :jiffy.encode(term, [:use_nil]) end
}

data = [
  "Blockchain"
  # "Giphy",
  # "GitHub",
  # "GovTrack",
  # "Issue 90",
  # "JSON Generator",
  # "Pokedex",
  # "UTF-8 unescaped"
]

inputs =
  for name <- data, into: %{} do
    name
    |> Exneus.Benchmark.read_data()
    |> Exneus.decode!()
    |> (&{name, &1}).()
  end

Exneus.Benchmark.run(
  "encode",
  jobs,
  inputs,
  %{
    graph: true
    # markdown: true,
    # save: true,
    # parallel: 1,
    # warmup: 5,
    # time: 5
    # memory_time: 1,
  }
)
