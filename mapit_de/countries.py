import re

# SRID to also output area geometry information in
area_geometry_srid = 4326


# Norwegian postcodes are four digits. Some put "no-" in front, but
# this is ignored here.
def is_valid_postcode(pc):
    if re.match('^(?!01000|99999)(0[1-9]\d{3}|[1-9]\d{4})$', pc):
        return True
    return False
