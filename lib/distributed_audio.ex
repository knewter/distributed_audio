defmodule DistributedAudio do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :pg2.create(:distributed_audio)

    children = [
      # Define workers and child supervisors to be supervised
      worker(DistributedAudio.Receiver, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistributedAudio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
