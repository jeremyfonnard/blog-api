# app/controllers/photos_controller.rb
class PhotosController < ApplicationController
  include Rails.application.routes.url_helpers # Nécessaire pour générer les URLs

  before_action :authenticate_user!
  before_action :set_photo, only: [:destroy]
  before_action :authorize_photo_owner, only: [:destroy]

  # POST /photos
  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      # On renvoie l'URL de l'image dans la réponse JSON
      render json: { id: @photo.id, user_id: @photo.user_id, image_url: url_for(@photo.image) }, status: :created
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /photos/:id
  def destroy
    @photo.destroy
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  # On autorise le paramètre "image" qui sera le fichier uploadé
  def photo_params
    params.permit(:image)
  end

  def authorize_photo_owner
    unless @photo.user == current_user
      render json: { error: "Vous n'êtes pas autorisé." }, status: :forbidden
    end
  end
end