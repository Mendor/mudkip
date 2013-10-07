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
         |> apply_links
         |> apply_lists
         |> apply_bold
         |> apply_italic
         |> apply_monospace
         |> apply_blockquotes
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
    case Regex.run(%r/^\s?[\*\+\-]/, line) do
      nil ->
        line
      _not_nil ->
        lc item inlist String.split(line, %r/\n\s?[\*\+\-]/) do
          format(:li, item)
        end
    end
  end

  defp apply_links(line) do
    line2 = Regex.replace(%r/<(.+(\:\/\/|@).+)>/, line, format_link("href=\"\\1\"", "\\1"))
    line3 = Regex.replace(%r/\[([^\]]+)\]\(([^\)\s]+)\)/, line2, format_link("href=\"\\2\"", "\\1"))
    Regex.replace(%r/\[([^\]]+)\]\(([^\)\s]+)\s([^\)]+)\)/, line3, format_link("title=\\3 href=\"\\2\"", "\\1"))
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

  defp apply_blockquotes(line) do
    case Regex.run(%r/^>\s?(.*)/, line) do
      nil ->
        line
      [_, line2] ->
        format(:blockquote, line2)
    end
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
