defmodule Chess.Store.Game do
  use Ecto.Schema
  use Timex.Ecto.Timestamps

  import Ecto.Changeset
  import Ecto.Query

  alias Chess.Board

  schema "games" do
    field :board, :map

    belongs_to :user, Chess.Auth.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:board, :user_id])
    |> put_change(:board, Board.default)
    |> validate_required([:board, :user_id])
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:board, :user_id])
    |> validate_required([:board, :user_id])
  end

  def for_user(query, user) do
    query
    |> where([game], user_id: ^user.id)
  end

  def ordered(query) do
    query
    |> order_by([game], desc: game.inserted_at)
  end
end
