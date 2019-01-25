defmodule Frontend.MonitoredService do
  def get_host_info(host_id) do
    %{
      "id" => host_id,
      "name" => "Test host",
      "icon" =>
        "https://www.uni-paderborn.de/typo3conf/ext/upb/Resources/Public/Files/gfx/logo.png"
    }
  end

  def get_services(host_id) do
    [
      %{
        "id" => 1,
        "name" => "Test http service",
        "host_id" => host_id,
        "type" => "mayor"
      },
      %{
        "id" => 2,
        "name" => "Test ping service",
        "host_id" => host_id,
        "type" => "mayor"
      },
      %{
        "id" => 3,
        "name" => "Test minor ping service",
        "host_id" => host_id,
        "type" => "minor"
      },
      %{
        "id" => 4,
        "name" => "Test minor http service",
        "host_id" => host_id,
        "type" => "minor"
      }
    ]
  end
end
