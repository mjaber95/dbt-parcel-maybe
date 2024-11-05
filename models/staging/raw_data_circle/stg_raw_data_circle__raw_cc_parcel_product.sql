with 

source as (

    select * from {{ source('raw_data_circle', 'raw_cc_parcel_product') }}

),

renamed as (

    select
        parcel_id,
        model_mame,
        quantity

    from source

)

select * from renamed
