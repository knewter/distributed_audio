defmodule DistributedAudio.Receiver do
  use GenServer
  alias Porcelain.Process, as: Proc

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def play(server, audio) do
    GenServer.cast(server, {:play, audio})
  end

  ## Server callbacks
  def init(:ok) do
    proc = %Proc{} = Porcelain.spawn("pacat", ["-p"], in: :receive, out: {:send, self})
    :pg2.join(:distributed_audio, self)
    {:ok, proc}
  end

  def handle_cast({:play, audio}, proc) do
    Proc.send_input(proc, audio)
    {:noreply, proc}
  end
end
