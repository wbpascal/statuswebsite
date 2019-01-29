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

  def search(search_string) do
    if :rand.uniform() > 0.8 do
      []
    else
      [
        %{
          "id" => 1,
          "name" => "UPB",
          "icon" =>
            "https://www.uni-paderborn.de/typo3conf/ext/upb/Resources/Public/Files/gfx/logo.png"
        },
        %{
          "id" => 42,
          "name" => "Reddit",
          "icon" =>
            "https://cdn0.iconfinder.com/data/icons/social-media-2092/100/social-36-512.png"
        }
      ]
    end
  end
end
