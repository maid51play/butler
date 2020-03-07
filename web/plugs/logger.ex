defmodule Butler.Plug.Logger do
    def log(struct, message, data \\ "[]") do
        %name{} = struct
        model_name = name |> Module.split |> Enum.at(-1) |> String.downcase
        model_atom = String.to_existing_atom("#{model_name}_id")
        changeset = Butler.Logging.changeset(%Butler.Logging{:operation => message, :data => data} |> Map.replace!(model_atom, struct.id))
        Butler.Repo.insert!(changeset)
    end
end
