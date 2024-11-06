{% macro clean_date(dirty_date) %}
    PARSE_DATE("%B %d, %Y", {{dirty_date}})
{% endmacro %}