defmodule Mudkip do

  def render_file(filename) do
    {:ok, content} = File.read(filename)
    render(content)
  end

  def render(indata) do
    indata_l = String.split(indata <> "\n", %r/\n\n+/)
    lc line inlist indata_l do
      try_render_line(line)
    end
  end

  defp try_render_line(line) do
    line |> apply_header
         |> apply_rulers
         |> apply_lists
         |> apply_links
         |> apply_bold
         |> apply_italic
         |> apply_monospace
         # |> apply_linebreaks_fix
         |> apply_paragraphs
  end

  defp apply_header(line) do
    case Regex.run(%r/^(#+)\s(.+)/, line) do
      [_line, hsize, value] ->
        format("h" <> %s(#{byte_size(hsize)}), Regex.replace(%r/(.*)\s#+$/, value, "\\1"))
      nil ->
        line2 = Regex.replace(%r/(.+)\n===+/, line, format(:h1, "\\1"))
        Regex.replace(%r/(.+)\n\-\-\-+/, line2, format(:h2, "\\1"))
    end
  end

  defp apply_rulers(line) do
    Regex.replace(%r/^([\.\-\*]\s*){3,100}$/, line, "<hr />")
  end

  defp apply_lists(line) do
    line
    # case Regex.run(%r/^\s?\*/, line) do
    #   nil ->
    #     line
    #   _not_nil ->
    #     elems = String.split(line, %r/\n\s?\*/)
    #     ["<ul>", lc item inlist elems do
    #       rendered = try_render_line(item)
    #       Regex.replace(%r/^(<p>)?(.*)(<\/p>)?$/, rendered, format(:li, "\\2"))
    #     end, "</ul>"]
    # end
  end

  defp apply_links(line) do
    line2 = Regex.replace(%r/<(.+(\:\/\/|@).+)>/, line, format_link("href=\"\\1\"", "\\1"))
    Regex.replace(%r/\[([^\]]+)\]\(([^\)]+)\)/, line2, format_link("href=\"\\2\"", "\\1"))
  end

  defp apply_bold(line) do
    line2 = Regex.replace(%r/(\*\*)([^\*]+)(\*\*)/, line, format(:strong, "\\2"))
    Regex.replace(%r/(__)([^_]+)(__)/, line2, format(:strong, "\\2"))
  end

  defp apply_italic(line) do
    line2 = Regex.replace(%r/(\*)(.+)(\*)/, line, format(:em, "\\2"))
    Regex.replace(%r/(_)(.+)(_)/, line2, format(:em, "\\2"))
  end

  defp apply_monospace(line) do
    Regex.replace(%r/`([^`]+)`/, line, format(:code, "\\1"))
  end

  defp apply_linebreaks_fix(line) do
    Regex.replace(%r/\n([^>\s].*)/, line, " \\1")
  end

  defp apply_paragraphs(line) do
    Regex.replace(%r/^([^<].*[^>])$/, line, format(:p, "\\1"))
  end

  defp format(tag, data) do
    "<" <> %s(#{tag}) <> ">" <> data <> "</" <> %s(#{tag}) <> ">"
  end

  defp format_link(params, data) do
    "<a " <> params <> ">" <> data <> "</a>"
  end
  
end
