# Releasing to the Steam Workshop

Transport Fever 2 uploads mods itself, from inside the game. There is no external tool and no
SteamCMD involved: the game reads a mod from the local mods folder, packs it and hands it to Steam.

## 1. Check the mod

```sh
luac -p mod.lua strings.lua res/config/game_script/*.lua res/config/style_sheet/*.lua res/scripts/grid_overlay/*.lua
lua test/test.lua
```

Both have to be clean. The tests also verify that every text is translated into every language the
game ships with, so a forgotten translation fails here rather than in the Workshop.

## 2. Copy the mod into the local mods folder

The folder name is `<author>_<mod>_<majorVersion>` and it is the identity of the mod: Steam
recognises an update by that name, so it must never change once the mod is published.

```
C:\Program Files (x86)\Steam\userdata\<steamId>\1066780\local\mods\microbrain_grid_1
```

The game uploads the folder as it is. It does not filter anything, so everything that is left in it
ends up in the Workshop item and in the download of every subscriber. Copy only what belongs there:

```sh
SRC=/mnt/f/TF2/transport-fever-2-grid
DST="/mnt/c/Program Files (x86)/Steam/userdata/255055249/1066780/local/mods/microbrain_grid_1"

rsync -a --delete \
  --exclude '.git' --exclude '.gitignore' \
  --exclude 'test' \
  --exclude 'image1.png' --exclude 'image2.png' \
  --exclude '*.svg' --exclude 'image_00.png' --exclude 'workshop_preview.png' \
  --exclude 'README.md' --exclude 'RELEASE.md' --exclude 'workshop_description.txt' \
  "$SRC/" "$DST/"
```

`--delete` matters for an update: a file that was removed from the repository has to disappear from
the mod folder as well, otherwise it stays in the Workshop item forever.

The one file the mod folder has that the repository does not is `workshop_fileid.txt`, and
`--exclude` does not touch it because it only exists on the destination side. `--delete` would
remove it, which is why it is copied back into the repository after the first upload (step 4) and
then travels with the source like every other file.

## 3. What ships and what does not

Ships, because the game or Steam reads it:

| File | Purpose |
| --- | --- |
| `mod.lua` | the mod itself; `minorVersion` is raised for every update |
| `strings.lua` | the texts in all 13 languages |
| `res/` | scripts, game script and style sheet |
| `image_00.tga` | the picture in the mod list of the game (400x225, 24 bit, uncompressed) |
| `workshop_preview.jpg` | the square picture of the Workshop page (666x666) |
| `workshop_fileid.txt` | written by the game after the first upload, never edit it by hand |
| `LICENSE` | the licence requires that it travels with every copy of the mod |

Does not ship:

| File | Why not |
| --- | --- |
| `.git/` | the history of the repository, useless to a player |
| `test/` | the test harness, it is only run from the repository |
| `image1.png`, `image2.png` | the screenshots of the Workshop page; they are uploaded through the page itself, not as part of the mod, and they alone are 4.2 MB |
| `image_00.svg`, `workshop_preview.svg` | the sources of the two pictures, the game reads the `.tga` and the `.jpg` |
| `image_00.png`, `workshop_preview.png` | the same pictures in a format nothing reads |
| `README.md`, `RELEASE.md` | developer documentation |
| `workshop_description.txt` | the text of the Workshop page, it is pasted into Steam rather than shipped |

That is 4.9 MB in the repository against 408 KB in the mod folder. Two of the 26 Workshop mods
installed here ship a leftover `.code-workspace`, which is what happens when the folder is copied
without excluding anything.

## 4. Upload from the game

1. Start Transport Fever 2.
2. Main menu, **Mods** (Staging area). The mod shows up with its picture and its name.
3. Select it and choose **Upload to Steam Workshop**.
4. For the first upload the game asks for the title, the description, the visibility and the tags.

   **A Workshop item has one title and one description for the whole world.** Steam does not offer
   a second language for them, so both have to be english. Steam translates the page around them
   (the buttons, the headings, the dates) for every visitor on its own, which is why the page looks
   russian here and english to someone else.

   The game runs in the language Steam is set to, so an uploader started from a russian game offers
   russian texts. Overwrite them: the title is `Grid` and the description is the text of
   `workshop_description.txt`, which is written in the BBCode Steam expects.

   The translations in `strings.lua` are a different thing and stay as they are. They are what the
   game shows in its own mod list and on the button, not what Steam shows.
5. Accept the Steam Workshop legal agreement if the game asks for it. Steam refuses the upload
   otherwise, and an item that was created but not accepted stays invisible.

After the upload the game writes `workshop_fileid.txt` into the mod folder. **Copy that file back
into the repository** - it is what ties every later update to the same Workshop item.

## 5. The Workshop page

The game only fills in the basics. Open the item on the Workshop and add:

* the screenshots (`image1.png`, `image2.png`)
* the tags `Script Mod` and `Misc`
* the visibility: `Public` once everything looks right

## 6. Updating later

1. Raise `minorVersion` in `mod.lua`.
2. Run the checks of step 1 again.
3. Copy the folder over as in step 2, with `workshop_fileid.txt` in place.
4. Upload from the game again. It recognises the existing item through the file id and updates it
   instead of creating a second one.

## Notes

* `severityAdd` and `severityRemove` are both `NONE`, which tells the game that the mod can be added
  to and removed from a running savegame without breaking it. That is true because the mod only
  draws and never touches the simulation. Do not change this without a reason.
* The major version in the folder name is only raised for a mod that is deliberately incompatible
  with its previous version. It creates a second, separate Workshop item.
