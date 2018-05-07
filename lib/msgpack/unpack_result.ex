defmodule UnpackResult do
  defstruct value: nil, rest: <<>>

  def new(value, rest) do
    %UnpackResult{
      value: value,
      rest: rest
    }
  end
end
