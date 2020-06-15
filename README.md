# QuantumStorageMnesia

[![Hex.pm Version](http://img.shields.io/hexpm/v/quantum_storage_mnesia.svg)](https://hex.pm/packages/quantum_storage_mnesia)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/quantum_storage_mensia)
[![Coverage Status](https://coveralls.io/repos/sezaru/quantum_storage_mnesia/badge.svg?branch=master)](https://coveralls.io/r/sezaru/quantum_storage_mnesia?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/dt/quantum_storage_mnesia.svg)](https://hex.pm/packages/quantum_storage_mnesia)

## Installation

The package can be installed by adding `quantum_storage_mnesia` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:quantum_storage_mnesia, "~> 0.1.0"}
  ]
end
```

To enable the storage adapter, add this to your `config.exs`:

```elixir
import Config

config :your_app, YourQuantumScheduler,
  storage: QuantumStorageMnesia
```

Documentation can be be found at [https://hexdocs.pm/quantum_storage_mnesia](https://hexdocs.pm/quantum_storage_mnesia).

