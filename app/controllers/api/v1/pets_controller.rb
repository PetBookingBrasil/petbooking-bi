class Api::V1::PetsController < Api::V1::BaseController
  def total_pets
    total_dog = Pet.by_businesses(business_ids)
                   .by_kind('dog')
                   .count

    total_cat = Pet.by_businesses(business_ids)
                   .by_kind('cat')
                   .count

    total = total_dog + total_cat

    pets = [{ total: total },
      { label: 'Cachorros',  value: total_dog},
      { label: 'Gatos',      value: total_cat}
    ]

    render json: { pets: pets }, status: :ok
  end

  def top_breeds_overall
    top_breeds_overall_dog = Pet.by_businesses(business_ids)
                                .by_kind('dog')
                                .by_top_breed

    top_breeds_overall_cat = Pet.by_businesses(business_ids)
                                .by_kind('cat')
                                .by_top_breed

    top_breeds_overall = [
      {label: 'Cachorros', value: top_breeds_overall_dog},
      {label: 'gatos', value: top_breeds_overall_cat},
    ]

    render json: { top_breeds_overall: top_breeds_overall }, status: :ok
  end

  def top_breeds_current_month
    date = Date.today - 1.day

    top_breeds_current_month = Pet.by_businesses(business_ids)
                                  .by_kind('dog')
                                  .by_current_month
                                  .by_top_breed
    render json: { top_breeds_current_month: top_breeds_current_month}, status: :ok
  end
end
