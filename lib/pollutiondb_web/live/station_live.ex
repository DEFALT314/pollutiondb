defmodule PollutiondbWeb.StationLive do
  use PollutiondbWeb, :live_view

  alias Pollutiondb.Station

    def mount(_params, _session, socket) do
    socket = assign(socket, stations: Station.getAll(), name: "", lat: "", lon: "", query: "")
    {:ok, socket}
  end
  def handle_event("insert", %{"name" => name, "lat" => lat, "lon" => lon}, socket) do
    Station.add(%Station{name: name, lat: to_float(lat, 0.0), lon: to_float(lon, 0.0)})
    socket = assign(socket, stations: Station.getAll(), name: name, lat: lat, lon: lon)
    {:noreply, socket}
  end
  def handle_event("search", %{"query" => query}, socket) do
    stationsFiltered = case query do
      "" -> Station.getAll()
      _ -> Station.find_by_name(query)
    end
    socket = assign(socket, stations: stationsFiltered, query: query)
    {:noreply, socket}
  end

  def to_float(x,def) do
    case Float.parse(x) do
      :error -> def
      {val, _} -> val
    end
  end



  def render(assigns) do
    ~H"""
    Create new station
  <form phx-submit="insert">
    Name: <input type="text" name="name" value={@name} /><br/>
    Lat: <input type="number" name="lat" step="0.1" value={@lat} /><br/>
    Lon: <input type="number" name="lon" step="0.1" value={@lon} /><br/>
    <input type="submit" />
  </form>

  Search
  <form phx-change="search">
    <input type="text" name="query" value={@query} /><br/>
  </form>


  <table>
      <tr>
        <th>Name</th><th>Longitude</th><th>Latitude</th>
      </tr>
      <%= for station <- @stations do %>
        <tr>
          <td><%= station.name %></td>
          <td><%= station.lon %></td>
          <td><%= station.lat %></td>
        </tr>
      <% end %>
    </table>
    """
  end
end
