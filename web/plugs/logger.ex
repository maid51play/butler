defmodule Butler.Plug.Logger do
    @moduledoc """
    Commits a struct change or event to the audit log
    """
    def log(struct, message, data \\ "[]") do
        %name{} = struct
        model_name = name |> Module.split |> Enum.at(-1) |> String.downcase
        model_atom = String.to_existing_atom("#{model_name}_id")
        changeset = Butler.Log.changeset(%Butler.Log{:message => message, :data => data} |> Map.replace!(model_atom, struct.id))
        Butler.Repo.insert!(changeset)
    end
end
