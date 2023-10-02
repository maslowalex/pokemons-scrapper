defmodule PokemonsCollector.Worker do
  use GenServer

  @flush_timeout 20_000

  require Logger

  defmodule State do
    defstruct pokemons: [], flush_timer_ref: nil
  end

  def add_pokemon(pokemon) do
    GenServer.call(__MODULE__, {:pokemon, pokemon})
  end

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call({:pokemon, structure}, _from, state) do
    new_state = %State{state | pokemons: [structure | state.pokemons]}

    {:reply, :ok, new_state, {:continue, :maybe_reset_timeout}}
  end

  def handle_continue(:maybe_reset_timeout, %State{flush_timer_ref: nil} = state) do
    ref = Process.send_after(self(), :flush, @flush_timeout)

    {:noreply, %State{state | flush_timer_ref: ref}}
  end

  def handle_continue(:maybe_reset_timeout, state) do
    Process.cancel_timer(state.flush_timer_ref)
    ref = Process.send_after(self(), :flush, @flush_timeout)

    {:noreply, %State{state | flush_timer_ref: ref}}
  end

  def handle_info(:flush, state) do
    pokemons = state.pokemons |> Poison.encode!()

    Logger.info("Saving pokemons to result.json!")
    File.write!("result.json", pokemons)

    {:noreply, %State{state | pokemons: [], flush_timer_ref: nil}}
  end
end
