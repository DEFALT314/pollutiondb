defmodule Pollutiondb.Station do
  require Ecto.Query
  use Ecto.Schema

  schema "stations" do
    field :name, :string
    field :lon, :float
    field :lat, :float
  end
  def add(station) do
    Pollutiondb.Repo.insert(station)
  end
  def getAll() do
    Pollutiondb.Repo.all(Pollutiondb.Station)
  end
  def get_by_id(id) do
    Pollutiondb.Repo.get(Pollutiondb.Station, id)
  end
  def remove(station) do
    Pollutiondb.Repo.delete(station)
  end
  def find_by_name(name) do
    Pollutiondb.Repo.all(
      Ecto.Query.where(Pollutiondb.Station, name: ^name) )
  end
  def find_by_location(lon, lat) do
    Ecto.Query.from(s in Pollutiondb.Station,
    where: s.lon == ^lon,
    where: s.lat == ^lat)
    |> Pollutiondb.Repo.all
  end
  def  find_by_location_range(lon_min, lon_max, lat_min, lat_max) do
    Ecto.Query.from(s in Pollutiondb.Station,
    where: s.lon >= ^lon_min,
    where: s.lon <= ^lon_max,
    where: s.lat >= ^lat_min,
    where: s.lat <= ^lat_max)
    |> Pollutiondb.Repo.all
  end
  def update_name(station, newname) do
    changeset(station, %{name: newname})
    |> Pollutiondb.Repo.update
  end

  def add(name, lon, lat) do
    changeset(%Pollutiondb.Station{}, %{name: name, lon: lon, lat: lat})
    |> Pollutiondb.Repo.insert
  end

  defp changeset(station, changesmap) do
    Ecto.Changeset.cast(station, changesmap, [:name, :lon, :lat])
  |> Ecto.Changeset.validate_number(:lon, greater_than_or_equal_to: -200, less_than_or_equal_to: 200)
  |> Ecto.Changeset.validate_number(:lat, greater_than_or_equal_to: -200, less_than_or_equal_to: 200)
  end
end
