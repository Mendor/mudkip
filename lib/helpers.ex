defmodule Mudkip.Helpers do
  
  def format(tag, data) do
    "<" <> %s(#{tag}) <> ">" <> data <> "</" <> %s(#{tag}) <> ">"
  end

  def format_link(params, data) do
    # mailed = Regex.replace(%r/href=\"([^(\:\/\/)]+@.+)\"/, params, "href=\"mailto:\1\"")
    "<a " <> params <> ">" <> data <> "</a>"
  end

  def format_img(data) do
    "<img " <> data <> " />"
  end

  def join(bins) do
    :erlang.list_to_binary bins
  end

end
