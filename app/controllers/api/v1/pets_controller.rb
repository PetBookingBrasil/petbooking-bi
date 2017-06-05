class Api::V1::PetsController < Api::V1::BaseController
  def total_pets
    pets = []

      total_dog = Pet.by_businesses(business_ids)
                     .by_kind('dog')
                     .count

      total_cat = Pet.by_businesses(business_ids)
                     .by_kind('cat')
                     .count

      total = total_dog + total_cat

      dog_percentage = (total_dog * 100)/total
      cat_percentage = (total_cat * 100)/total

    pets << {
      total: total,
      total_dog: total_dog,
      dog_percentage: dog_percentage,
      total_cat: total_cat,
      cat_percentage: cat_percentage
    }

    render json: { pets: pets }, status: :ok
  end

  def top_breeds

    top_overall = Pet.by_businesses(business_ids)
                     .by_kind('dog')
                     .order('breeds.id')

    render json: { top_overall: top_overall }, status: :ok
  end
end
