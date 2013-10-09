defmodule Mudkip.Rules.Default do

  alias Mudkip.Helpers, as: MH

  def render(data) do
    MH.join(lc line inlist data do
      try_render_line(line)
    end)
  end

  defp try_render_line(line) do
    preline = apply_pre(line)
    if line == preline do
      line |> apply_header
           |> apply_rulers
           |> apply_images
           |> apply_links
           |> apply_lists
           |> apply_bold
           |> apply_italic
           |> apply_monospace
           |> apply_blockquotes
           |> apply_linebreaks_fix
           |> apply_paragraphs
    else
      preline
    end
  end

  defp apply_pre(line) do
    case Regex.run(%r/^(?:\s{4}|\t)(.*)$/s, line) do
      nil ->
        line
      [_, found] ->
        MH.format(:pre, Regex.replace(%r/(?:\n\s{4}|\t)(.*)/, found, "\\1"))
    end
  end

  defp apply_header(line) do
    case Regex.run(%r/^(#+)\s(.+)/, line) do
      [_line, hsize, value] ->
        MH.format("h" <> %s(#{byte_size(hsize)}), Regex.replace(%r/(.*)\s#+$/, value, "\\1"))
      nil ->
        line2 = Regex.replace(%r/(.+)\n===+/, line, MH.format(:h1, "\\1"))
        Regex.replace(%r/(.+)\n\-\-\-+/, line2, MH.format(:h2, "\\1"))
    end
  end

  defp apply_rulers(line) do
    Regex.replace(%r/^([\.\-\*]\s*){3,100}$/, line, "<hr />")
  end

  defp apply_lists(line) do
    uls = case Regex.run(%r/^\s?[\*\+\-]\s(.*)$/s, line) do
      nil ->
        line
      [_, found] ->
        MH.format(:ul, MH.join(lc item inlist String.split(found, %r/\n\s?[\*\+\-]\s/) do
          MH.format(:li, item)
        end))
    end
    case Regex.run(%r/^\s?[0-9]\.\s(.*)$/s, uls) do
      nil ->
        uls
      [_, found] ->
        MH.format(:ol, MH.join(lc item inlist String.split(found, %r/\n\s?[0-9]\.\s/) do
          MH.format(:li, item)
        end))
    end
    
  end

  defp apply_images(line) do
    line2 = Regex.replace(%r/\!\[([^\]]+)\]\(([^\)\s]+)\)/, line, MH.format_img("src=\"\\2\" alt=\"\\1\""))
    Regex.replace(%r/\!\[([^\]]+)\]\(([^\)\s]+)\s([^\)]+)\)/, line2, MH.format_img("title=\\3 src=\"\\2\" alt=\"\\1\""))
  end

  defp apply_links(line) do
    line2 = Regex.replace(%r/<((?!img\s).+(\:\/\/|@).+)>/, line, MH.format_link("href=\"\\1\"", "\\1"))
    line3 = Regex.replace(%r/\[([^\]]+)\]\(([^\)\s]+)\)/, line2, MH.format_link("href=\"\\2\"", "\\1"))
    Regex.replace(%r/\[([^\]]+)\]\(([^\)\s]+)\s([^\)]+)\)/, line3, MH.format_link("title=\\3 href=\"\\2\"", "\\1"))
  end

  defp apply_bold(line) do
    line2 = Regex.replace(%r/(\*\*)([^\*]+)(\*\*)/, line, MH.format(:strong, "\\2"))
    Regex.replace(%r/(__)([^_]+)(__)/, line2, MH.format(:strong, "\\2"))
  end

  defp apply_italic(line) do
    line2 = Regex.replace(%r/(\*)(.+)(\*)/, line, MH.format(:em, "\\2"))
    Regex.replace(%r/(_)(.+)(_)/, line2, MH.format(:em, "\\2"))
  end

  defp apply_monospace(line) do
    Regex.replace(%r/`([^`]+)`/, line, MH.format(:pre, "\\1"))
  end

  defp apply_blockquotes(line) do
    case Regex.run(%r/^>\s?(.*)/, line) do
      nil ->
        line
      [_, line2] ->
        Mudkip.Helpers.format(:blockquote, line2)
    end
  end

  defp apply_linebreaks_fix(line) do
    Regex.replace(%r/\n([^>\s].*)/, line, " \\1")
  end

  defp apply_paragraphs(line) do
    Regex.replace(%r/^((?!(<h|<blo|<ul|<ol|<pre)).*)$/s, line, MH.format(:p, "\\1"))
  end

end
