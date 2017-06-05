class Api::V1::PetsController < Api::V1::BaseController
  def total_pets
    pets = []

    if (business_ids != business_ids.empty?)
      total = Pet.by_businesses(business_ids)
                 .count

      total_dog = Pet.by_businesses(business_ids)
                     .joins(:breed)
                     .where('breeds.kind = dog')
                     .count

      total_cat = Pet.by_businesses(business_ids)
                     .joins(:breed)
                     .where('breeds.kind = cat')
                     .count
    else
      total = Pet.by_businesses(business_ids)
                 .count

      total_dog = Pet.by_businesses(business_ids)
                     .joins(:breed)
                     .where('breeds.kind = dog')
                     .count

      total_cat = Pet.by_businesses(business_ids)
                     .joins(:breed)
                     .where('breeds.kind = cat')
                     .count
    end

    pets << {
      total: total,
      total_dog: total_dog,
      total_cat: total_cat
    }

    render json: { pets: pets }, status: :ok
  end
end
