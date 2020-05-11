defmodule Mix.Tasks.FinanceTs.Gen.Adapter do
  @moduledoc """
  Generates an api adapter.

      mix finance_ts.gen.adapter ApiName

  Accepts the api name for the adapter

  The generated files will contain:

    * an adapter in lib/finance_ts/adapters
    * an adapter_test in test/finance_ts/adapters
  """
  use Mix.Task

  alias Mix.Generator

  @doc false
  def run(args) do
    [exchange_name] = validate_args!(args)

    binding = [
      path: Macro.underscore(exchange_name),
      scoped: Macro.camelize(exchange_name)
    ]

    copy_templates("priv/templates/finance_ts.gen.adapter", binding, [
      {"adapter.ex", "lib/finance_ts/adapters/#{binding[:path]}.ex"},
      {"adapter_test.exs", "test/finance_ts/adapters/#{binding[:path]}_test.exs"}
    ])

    Mix.shell().info("""
      Adapter generated: #{binding[:scoped]}Adapter
    """)
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise("""
    mix exchange.gen.adapter expects an api name:

        mix exchange.gen.adapter ApiName
    """)
  end

  defp validate_args!(args) do
    unless length(args) == 1 do
      raise_with_help()
    end

    args
  end

  defp copy_templates(root, binding, mappings) when is_list(mappings) do
    for {source_file_path, target} <- mappings do
      source = Path.join(root, source_file_path)
      Generator.create_file(target, EEx.eval_file(source, binding))
    end
  end
end
