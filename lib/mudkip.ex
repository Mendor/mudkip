defmodule Mudkip do

  def render_file(filename) do
    render_file(filename, :default)
  end

  def render_file(filename, style) do
    {:ok, content} = File.read(filename)
    render(content, style)
  end

  def render(indata) do
    render(indata, :default)
  end

  def render(indata, style) do
    indata_l = String.split(indata <> "\n", %r/\n\n+/)
    apply(Mudkip.Rules.style, render, [indata_l])
  end
  
end
