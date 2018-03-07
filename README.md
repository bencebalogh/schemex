# Schemex

Small Elixir wrapper for [Confluent Schema Registry](https://github.com/confluentinc/schema-registry).

## Installation

Add `schemex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:schemex, "~> 0.1.1"}
  ]
end
```

Run `mix deps.get`

## Usage

Each functions' first parameter is the host of the Schema Registry, this way the user of the library can decide configuration approach.
Hex documentation can be found [here](https://hexdocs.pm/schemex)

Available functions:

### config(host)
Get top level configuration.

### subjects(host)
List all subjects.

### versions(host, subject)
List versions of a subject.

### version(host, subject, version)
Get specific version of a subject.

### latest(host, subject)
Get latest version of a subject.

### schema(host, id)
Get schema specified by unique global id.

### delete(host, subject)
Delete a subject.

### delete(host, subject, version)
Delete a subject's version.

### register(host, subject, schema)
Register a new schema version under a subject.

### check(host, subject, schema)
Check if schema has been registered under a subject.

### test(host, subject, schema, version \\\ "latest")
Test if a schema's compatibility with a specific version under subject.

### update_compatibility(host, compability)
Update compatibility requirements globally.

### update_compatibility(host, subject, compability)
Update compatibility requirements under a subject.

