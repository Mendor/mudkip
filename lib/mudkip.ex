defmodule Mudkip do

  @moduledoc """
    Main Mudkip module. Is an API to rendering rules sets mostly.
  """

  @doc """
    Reads Markdown source content from the file and compiles it using "Default" rules module.
  """
  def compile_file(filename) do
    compile_file(filename, 'Default')
  end

  @doc """
    Reads Markdown source countent from the file and compiles it using required rules module.
  """
  def compile_file(filename, style) do
    {:ok, content} = File.read(filename)
    compile(content, style)
  end

  @doc """
    Compiles Markdown source from the binary variable using "Default" rules module.
  """
  def compile(indata) do
    compile(indata, 'Default')
  end

  @doc """
    Compiles Markdown source from the binary variable using required rules module.
  """
  def compile(indata, style) do
    indata_l = String.split(indata <> "\n", %r/\n\n+/)
    apply(Module.concat(Mudkip.Rules, style), :render, [indata_l])
  end
  
end
