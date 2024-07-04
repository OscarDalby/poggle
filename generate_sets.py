import pyperclip


def letter_to_number(letter):
    return ord(letter) - ord('A') + 1


tiles_4x4_new = [
    "AAEEGN", "ELRTTY", "AOOTTW", "ABBJOO", "EHRTVW", "CIMOTU",
    "DISTTY", "EIOSST", "DELRVY", "ACHOPS", "HIMNQU", "EEINSU",
    "EEGHNW", "AFFKPS", "HLNNRZ", "DEILRX"
]

tiles_4x4_classic = [
    "AACIOT", "AHMORS", "EGKLUY", "ABILTY", "ACDEMP", "EGINTV",
    "GILRUW", "ELPSTU", "DENOSW", "ACELRS", "ABJMOQ", "EEFHIY",
    "EHINPS", "DKNOTU", "ADENVZ", "BIFORX"
]


def convert_and_copy_tiles(tiles):
    output_str = ""
    output_array = []
    for tile in tiles:
        tile_array = []
        iterable_tile = list(tile)
        for char in iterable_tile:
            tile_array.append(letter_to_number(char))
        output_array.append(tile_array)
        output_str = str(output_array).replace("[", "{").replace("]", "}")
        pyperclip.copy(output_str)
    return output_str


# new = convert_and_copy_tiles(tiles_4x4_new)
classic = convert_and_copy_tiles(tiles_4x4_classic)
