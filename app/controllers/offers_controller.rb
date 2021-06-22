class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  layout 'home'

  def index
    @offers = Offer.all
  end

  def edit
  end

  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to offers_path, notice: 'Offer was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:percentage, :user_type, :description)
  end
end