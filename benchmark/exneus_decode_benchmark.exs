Code.eval_file("exneus_benchmark.exs", "./benchmark")

jobs = %{
  "Exneus" => &Exneus.decode!/1,
  "euneus" => fn json -> :euneus.decode(json, %{null: nil}) end,
  "json (OTP)" => &:json.decode/1,
  "thoas" => &:thoas.decode/1,
  "Jason" => &Jason.decode!/1,
  "JSON" => &JSON.decode!/1,
  "jsone" => &:jsone.decode/1,
  "jsx" => &:jsx.decode/1,
  "jiffy" => fn json -> :jiffy.decode(json, [:return_maps, :use_nil]) end
}

data = [
  "Blockchain"
  # "Giphy",
  # "GitHub",
  # "GovTrack",
  # "Issue 90",
  # "JSON Generator (Pretty)",
  # "JSON Generator",
  # "Pokedex",
  # "UTF-8 escaped",
  # "UTF-8 unescaped"
]

inputs =
  for name <- data, into: %{} do
    name
    |> Exneus.Benchmark.read_data()
    |> (&{name, &1}).()
  end

Exneus.Benchmark.run(
  "decode",
  jobs,
  inputs,
  %{
    graph: true
    # markdown: true,
    # save: true,
    # parallel: 1,
    # warmup: 5,
    # time: 5,
    # memory_time: 1,
  }
)
