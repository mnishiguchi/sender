defmodule ConcurrentDataProcessing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Task.Supervisor is a builtin supervisor
      {Task.Supervisor, name: SenderTaskSupervisor},
      Jobber.Registry,
      Jobber.Runner,
      Scraper.OnlinePageProducerConsumerRegistry,
      Scraper.PageProducer,
      Scraper.OnlinePageProducerConsumer.child_spec(id: 1),
      Scraper.OnlinePageProducerConsumer.child_spec(id: 2),
      Scraper.PageConsumerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConcurrentDataProcessing.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
