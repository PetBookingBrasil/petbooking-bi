class Api::V1::PetsController < Api::V1::BaseController
  def total_pets
    total_dog = Pet.by_businesses(business_ids)
                   .by_kind('dog')
                   .count

    total_cat = Pet.by_businesses(business_ids)
                   .by_kind('cat')
                   .count

    total = total_dog + total_cat

    pets = [{ label: 'Total',      value: total},
      { label: 'Cachorros',  value: total_dog},
      { label: 'Gatos',      value: total_cat}
    ]

    render json: { pets: pets }, status: :ok
  end

  def top_breeds

    top_overall = Pet.by_businesses(business_ids)
                     .by_kind('dog')
                     .order('breeds.id')

    render json: { top_overall: top_overall }, status: :ok
  end
end
