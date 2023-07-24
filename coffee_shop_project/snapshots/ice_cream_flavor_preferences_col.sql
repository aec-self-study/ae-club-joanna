{% snapshot ice_cream_flavor_preferences_col %}
 
{{ config(
      target_schema='dbt_joanna_snapshots',
      unique_key='github_username',
      strategy='check',
      check_cols='all',
) }}
 
select
    *
from {{ source('advanced_dbt_examples', 'favorite_ice_cream_flavors') }}
 
{% endsnapshot %}