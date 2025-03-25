# app/controllers/beverages_controller.rb
class BeveragesController < ApplicationController
  before_action :set_beverage, only: [:show, :edit, :update, :destroy]

  def index
    @beverages = Beverage.order(date: :desc, consumption_time: :desc)
  end

  def show
    @tips = generate_personalized_tips(@beverage)
  end

  def new
    @beverage = Beverage.new
    @beverage.additions.build
    @beverage.symptoms.build
    @beverage.build_note
  end

  def edit
    # Ensure we have at least one of each nested attribute
    @beverage.additions.build if @beverage.additions.empty?
    @beverage.symptoms.build if @beverage.symptoms.empty?
    @beverage.build_note unless @beverage.note
  end

  def create
    @beverage = Beverage.new(beverage_params)
    
    if @beverage.save
      @beverage.calculate_calories
      redirect_to @beverage, notice: 'Beverage was successfully tracked.'
    else
      render :new
    end
  end

  def update
    if @beverage.update(beverage_params)
      @beverage.calculate_calories
      redirect_to @beverage, notice: 'Beverage was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @beverage = Beverage.find(params[:id])
    @beverage.destroy
    
    respond_to do |format|
      format.html { redirect_to beverages_url, notice: 'Beverage was successfully deleted.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@beverage) }
    end
  end

  private

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end

  def beverage_params
    params.require(:beverage).permit(
      :date, 
      :consumption_time, 
      :category, 
      :subcategory, 
      :quantity, 
      :unit, 
      :temperature, 
      :photo,
      additions_attributes: [:id, :name, :_destroy],
      symptoms_attributes: [:id, :occurred, :name, :severity, :timing, :_destroy],
      note_attributes: [:id, :content, :_destroy]
    )
  end

  def generate_personalized_tips(beverage)
    tips = []

    if beverage.symptoms.any? { |s| s.name == 'Acid Reflux / Heartburn' } && 
       beverage.temperature == 'Hot'
      tips << "Hot drinks can trigger acid reflux; try drinking at a warm or room temperature instead."
    end

    if beverage.symptoms.any? { |s| s.name == 'Bloating' } && 
       beverage.category == 'Carbonated & Artificially Sweetened Drinks'
      tips << "Carbonated beverages may contribute to bloating; try limiting intake."
    end

    if beverage.symptoms.any? { |s| ['Dry Mouth / Sticky Saliva', 'Headache'].include?(s.name) } && 
       beverage.category == 'Carbonated & Artificially Sweetened Drinks'
      tips << "High sugar intake can lead to dehydration; consider switching to water or herbal tea."
    end

    tips
  end
end