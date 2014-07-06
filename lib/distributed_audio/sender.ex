defmodule DistributedAudio.Sender do
  use GenServer
  alias Porcelain.Process, as: Proc

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server callbacks
  def init(:ok) do
    proc = %Proc{} = Porcelain.spawn("pacat", ["-r"], in: :receive, out: {:send, self})
    {:ok, proc}
  end

  def handle_info({pid, :data, audio}, proc=%Proc{pid: procpid}) when pid == procpid do
    distribute(audio)
    {:noreply, proc}
  end

  def handle_info(noclue, proc) do
    IO.puts "unhandled info"
    IO.inspect noclue
    {:noreply, proc}
  end

  def distribute(audio) do
    for pid <- :pg2.get_members(:distributed_audio) do
      DistributedAudio.Receiver.play(pid, audio)
    end
  end
end
