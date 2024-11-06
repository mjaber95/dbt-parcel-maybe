with 

source as (

    select * from {{ source('raw_data_circle', 'raw_cc_parcel') }}

),

renamed as (

    select
        parcel_id,
        parcel_tracking,
        transporter,
        priority,
        PARSE_DATE("%B %d, %Y", date_purchase) AS date_purchase,
        PARSE_DATE("%B %d, %Y", date_shipping) AS date_shipping,
        PARSE_DATE("%B %d, %Y",date_delivery) AS date_delivery,
        PARSE_DATE("%B %d, %Y",datecancelled) AS date_cancelled

    from source

)

select * from renamed
