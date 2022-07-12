defmodule Fracomex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :mail_address, :string
    field :name, :string
    field :password, :string
    field :phone_number, :string
    field :street, :string
    field :country_id, :id
    field :city_id, :id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :firstname, :mail_address, :street, :phone_number, :password, :country_id, :city_id])
    |> validate_required([:name, :firstname, :mail_address, :street, :phone_number, :password, :country_id, :city_id])
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :firstname, :mail_address, :phone_number, :password, :country_id, :city_id])
    |> validate_required(:name, message: "Entrez votre nom")
    |> validate_required(:firstname, message: "Entrez votre prénom")
    |> validate_required(:mail_address, message: "Entrez votre adresse email")
    |> validate_required(:phone_number, message: "Entrez votre téléphone")
    |> validate_required(:password, message: "Entrez mot de passe")
    |> validate_required(:country_id, message: "Sélectionnez un pays")
    |> validate_required(:city_id, message: "Sélectionnez une ville")
    |> validate_format(:mail_address, ~r<(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])>, message: "Format d'email non valide")
    |> unique_constraint(:mail_address, message: "Adresse email déjà pris")
    |> validate_format(:phone_number, ~r/^[0-9][A-Za-z0-9 -]*$/, message: "Entrez un numéro")
    |> validate_password_confirmation(attrs)
  end

  defp validate_password_confirmation(changeset, attrs) do
    password = get_change(changeset, :password)
    cond do
      is_nil(attrs[:password_confirmation]) ->
        add_error(changeset, :password_confirmation, "Confirmez le mot de passe")
      password != attrs[:password_confirmation] ->
        add_error(changeset, :password_confirmation, "Les mots de passe doivent être identiques")
      true ->
        changeset
    end
  end

end
