import re

# SRID to also output area geometry information in
#area_geometry_srid = 32633


# Norwegian postcodes are four digits. Some put "no-" in front, but
# this is ignored here.
def is_valid_postcode(pc):
    if re.match('^0[1-9]\d\d(?<!0100)0|0[1-9]\d\d[1-9]|[1-9]\d{3}[0-8]|[1-9]\d{3}(?<!9999)9$', pc):
        return True
    return False


# Should match one, two and three digits.
def is_valid_partial_postcode(pc):
    if re.match('^0[1-9]\d\d(?<!0100)0|0[1-9]\d\d[1-9]|[1-9]\d{3}[0-8]|[1-9]\d{3}(?<!9999)9$', pc):
        return True
    return False
