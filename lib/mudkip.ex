defmodule Mudkip do

  def render_file(filename) do
    render_file(filename, 'Default')
  end

  def render_file(filename, style) do
    {:ok, content} = File.read(filename)
    render(content, 'Default')
  end

  def render(indata) do
    render(indata, 'Default')
  end

  def render(indata, style) do
    indata_l = String.split(indata <> "\n", %r/\n\n+/)
    apply(Module.concat(Mudkip.Rules, style), :render, [indata_l])
  end
  
end
