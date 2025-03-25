# app/models/beverage.rb
class Beverage < ApplicationRecord
    has_many :additions, dependent: :destroy
    has_many :symptoms, dependent: :destroy
    has_one :note, dependent: :destroy
  
    accepts_nested_attributes_for :additions, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :symptoms, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :note, allow_destroy: true, reject_if: :all_blank
  
    validates :date, presence: true
    validates :category, presence: true
    validates :quantity, presence: true, numericality: { greater_than: 0 }
    validates :unit, presence: true
  
    CATEGORIES = [
      'Water-Based Beverages',
      'Coffee-Based Beverages',
      'Tea-Based Beverages',
      'Juice & Smoothies',
      'Dairy-Based Beverages',
      'Plant-Based Milks',
      'Fermented & Probiotic Beverages',
      'Carbonated & Artificially Sweetened Drinks',
      'Alcoholic Beverages',
      'Other'
    ]
  
    SUBCATEGORIES = {
      'Water-Based Beverages' => ['Plain Water', 'Infused Water', 'Coconut Water', 'Electrolyte-Infused Water', 'Oral Rehydration Solutions'],
      'Coffee-Based Beverages' => ['Black Coffee', 'Espresso', 'Americano', 'Cold Brew', 'Latte', 'Cappuccino', 'Mocha'],
      'Tea-Based Beverages' => ['Green Tea', 'Black Tea', 'White Tea', 'Oolong Tea', 'Herbal Tea', 'Matcha', 'Yerba Mate'],
      'Juice & Smoothies' =>['Fresh Fruit Juice (Apple, Orange, Pomegranate, etc.)','Vegetable Juice (Carrot, Beet, Celery, etc.)','Blended Smoothies (Fruit-Based)','Blended Smoothies (Vegetable-Based)'],
      'Dairy-Based Beverages' =>['Whole Milk', 'Low-Fat Milk','Skim Milk','Lactose-Free Milk','Kefir','Buttermilk'],
      'Plant-Based Milks'=>['Almond Milk (Unsweetened)','Almond Milk (Sweetened)','Oat Milk (Unsweetened)','Oat Milk (Sweetened)','Soy Milk','Coconut Milk','Rice Milk','Hemp Milk'],
      'Fermented & Probiotic Beverages'=>['Kombucha','Lassi','Yakult','Kvass',],
      'Carbonated & Artificially Sweetened Drinks'=>['Regular Soda',' Diet Soda',' Sparkling Water',' Energy Drinks',' Sports Drinks (Gatorade, Powerade)'],
      'Alcoholic Beverages'=>['Beer','Wine','Cider','Cocktails','Liquor (Vodka, Whiskey, Gin, Tequila)'],
      'Other'=>[]
      # Add other categories and subcategories
    }
  
    UNITS = [
      'ml', 'oz', 'cup', 'fl oz', 'liter', 'pint', 'bottle',
      'can', 'serving', 'shot', 'Other'
    ]
  
    # Validate category
    validate :validate_category
  
    # Validate subcategory
    validate :validate_subcategory
  
    # Validate unit
    validate :validate_unit
  
    # Validate that at least one symptom is present if 'Symptoms Occurred?' is checked
    validate :at_least_one_symptom_if_occurred
  
    def calculate_calories
      # Basic calorie calculation logic
      calories = 0
      additions.each do |addition|
        calories += calorie_for_addition(addition.name)
      end
      update(calories: calories)
    end

    
    def get_personalized_tip
      tips = []
  
      if symptoms.any? { |s| s.name == 'Acid Reflux / Heartburn' } && category == 'Coffee-Based Beverages' || category == 'Tea-Based Beverages' && temperature.in?(['hot', 'boiling'])
        tips << "Hot drinks can trigger acid reflux; try drinking at a warm or room temperature instead."
      end
  
      if symptoms.any? { |s| s.name == 'Bloating' } && (category == 'Carbonated & Artificially Sweetened Drinks' || subcategory&.include?('Carbonated'))
        tips << "Carbonated beverages may contribute to bloating; try limiting intake."
      end
  
      if symptoms.any? { |s| s.name.in?(['Dry Mouth / Sticky Saliva', 'Headache']) } && category == 'Juice & Smoothies' && quantity > 1 # Example: high quantity
        tips << "High sugar intake can lead to dehydration; consider switching to water or herbal tea."
      end
  
      tips.uniq.join(" ") # Return a single string with unique tips
    end
  
    private
  
    def validate_category
      # Allow custom category if 'Other' is selected
      return true if category == 'Other' || CATEGORIES.include?(category)
  
      errors.add(:category, "must be a valid category or 'Other'")
    end
  
    def validate_subcategory
      # If a predefined category is selected, validate subcategory
      if CATEGORIES.include?(category)
        # For 'Other' category, allow any subcategory
        return true if category == 'Other'
  
        # Check if subcategory is in the predefined list for the category
        predefined_subcategories = SUBCATEGORIES[category] || []
        return true if predefined_subcategories.include?(subcategory)
  
        errors.add(:subcategory, "must be a valid subcategory for #{category}")
      end
  
      true
    end
  
    def validate_unit
      # Allow custom unit if 'Other' is selected
      return true if unit == 'Other' || UNITS.include?(unit)
  
      errors.add(:unit, "must be a valid unit or 'Other'")
    end
  
    def calorie_for_addition(addition_name)
      case addition_name&.downcase
      when 'sugar' then 15
      when 'milk' then 10
      when 'creamer' then 20
      else 0
      end
    end

  
    def at_least_one_symptom_if_occurred
      if symptoms.any? { |symptom| symptom.occurred == true }
        if symptoms.none? { |symptom| symptom.name.present? }
          errors.add(:symptoms, "must include at least one symptom name when 'Symptoms Occurred?' is checked")
        end
      end
    end
  end
  
  # app/models/addition.rb
  class Addition < ApplicationRecord
    belongs_to :beverage
  
    validates :name, presence: true
  
    COMMON_ADDITIONS = [
      'Sugar', 'Milk', 'Creamer', 'Lemon', 'Lime',
      'Honey', 'Artificial Sweeteners', 'Protein Powder',
      'Electrolyte Powder'
    ]
  end
  
  # app/models/symptom.rb
  class Symptom < ApplicationRecord
    belongs_to :beverage
  
    validates :name, presence: true, if: :occurred?
    validates :severity, inclusion: { in: ['Mild', 'Moderate', 'Severe'], allow_blank: true }, if: :occurred?
    validates :timing, inclusion: {
      in: ['Immediately', 'Within 20–30 minutes', '2–5 hours', '5+ hours later'],
      allow_blank: true
    }, if: :occurred?
  
    COMMON_SYMPTOMS = [
      'Bloating', 'Discomfort', 'Nausea', 'Acid Reflux / Heartburn',
      'Burping / Excess Gas', 'Diarrhea / Loose Stools', 'Constipation',
      'Cramping / Abdominal Pain', 'Urgency to Poop', 'Mucus in Stool',
      'Fatty / Oily Stools', 'Undigested Food in Stool',
      'Feeling Full / Heavy Stomach', 'Dizziness', 'Headache',
      'Dry Mouth / Sticky Saliva'
    ]
  
    def occurred?
      occurred
    end
  end
  
  # app/models/note.rb
  class Note < ApplicationRecord
    belongs_to :beverage
  
    validates :content, length: { maximum: 500, allow_blank: true }
  end