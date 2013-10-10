defmodule Mudkip.Helpers do

  @moduledoc """
    Mudkip helpers that could be called from anywhere. Currently are used mostly for HTML
    formatting methods.
  """

  @doc """
    Adding required HTML tag (should be an atom) to the data.
  """
  def format(tag, data) do
    "<" <> %s(#{tag}) <> ">" <> data <> "</" <> %s(#{tag}) <> ">"
  end

  @doc """
    Create HTML link with required parameters.
  """
  def format_link(params, data) do
    # mailed = Regex.replace(%r/href=\"([^(\:\/\/)]+@.+)\"/, params, "href=\"mailto:\1\"")
    "<a " <> params <> ">" <> data <> "</a>"
  end

  @doc """
    Create HTML image tag with required parameters.
  """
  def format_img(data) do
    "<img " <> data <> " />"
  end

  @doc """
    Shortcut to merge list of binaries.
  """
  def join(bins) do
    :erlang.list_to_binary bins
  end

end
